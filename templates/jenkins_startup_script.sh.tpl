#!/bin/bash

set -e

function get_jenkins_auth_code() {
  USERNAME="${jenkins_username}"
  PASSWORD="${jenkins_password}"

  set +e
  _last_exit_code=1
  echo "Waiting for Jenkins to come online"
  while [ "$${_last_exit_code}" != "0" ]; do
    printf '.'
    JENKINS_AUTH_CRUMB=$(wget -q --auth-no-challenge --user "$${USERNAME}" --password "$${PASSWORD}" --output-document - 'http://localhost/jenkins/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
    _last_exit_code=$?
    sleep 5
  done
  set -e

  echo "\nJenkins is online; proceeding"
}

install_system_dependencies() {
  echo "Installing system dependencies"
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for apt to finish..."
    sleep 0.5
  done
  echo "Apt finished; continuing..."
  apt -y update
  apt-get install -y -qq python-pip
}

install_python_dependencies() {
  echo "Installing python dependencies"
  pip install python-jenkins
  pip install requests
}

generate_ssh_key() {
  echo "Generating SSH key for Jenkins configuration"
  ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null
}

install_ssh_key() {
  echo "Installing SSH key for Jenkins configuration"

  jenkins_user_config_path=$(find /opt/bitnami/apps/jenkins/jenkins_home/users/ -type f -name config.xml)
  ssh_public_key_path=/root/.ssh/id_rsa.pub

  /bin/cat <<EOF >/tmp/add_ssh_key.py
import xml.etree.ElementTree as ET
import requests

f = open('$${ssh_public_key_path}', 'r')
ssh_public_key = f.read().replace('\n', '')

tree = ET.parse('$${jenkins_user_config_path}')
root = tree.getroot()
el = '''
<org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
  <authorizedKeys>{0}</authorizedKeys>
</org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
'''.format(ssh_public_key)

properties = root.find('properties')
ssh_keys = properties.findall('org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl')
for key_element in ssh_keys:
  properties.remove(key_element)
properties.append(ET.fromstring(el))

tree.write('$${jenkins_user_config_path}')
EOF
  python /tmp/add_ssh_key.py
  restart_jenkins
}

enable_jenkins_cli() {
  echo "Enabling Jenkins CLI over SSH"

  /bin/cat <<EOF >/opt/bitnami/apps/jenkins/jenkins_home/org.jenkinsci.main.modules.sshd.SSHD.xml
<?xml version='1.1' encoding='UTF-8'?>
<org.jenkinsci.main.modules.sshd.SSHD>
  <port>0</port>
</org.jenkinsci.main.modules.sshd.SSHD>
EOF
  restart_jenkins
}

disable_jenkins_cli() {
  echo "Disabling Jenkins CLI over SSH"

  rm -rf /opt/bitnami/apps/jenkins/jenkins_home/org.jenkinsci.main.modules.sshd.SSHD.xml

  restart_jenkins
}

download_jenkins_cli() {
  wget -O /tmp/jenkins-cli.jar http://localhost/jenkins/jnlpJars/jenkins-cli.jar
}

uninstall_ssh_key() {
  echo "Uninstalling SSH key for Jenkins configuration"

  jenkins_user_config_path=$(find /opt/bitnami/apps/jenkins/jenkins_home/users/ -type f -name config.xml)

  /bin/cat <<EOF >/tmp/add_ssh_key.py
import xml.etree.ElementTree as ET
import requests

tree = ET.parse('$${jenkins_user_config_path}')
root = tree.getroot()
properties = root.find('properties')
ssh_keys = properties.findall('org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl')
for key_element in ssh_keys:
  properties.remove(key_element)

tree.write('$${jenkins_user_config_path}')
EOF
  python /tmp/add_ssh_key.py
  rm -rf ~/.ssh/id_rsa*
}

skip_jenkins_install_wizard() {
  echo "Skipping install wizard"
  get_jenkins_auth_code
  _result=$(curl -vv -X POST -H "$${JENKINS_AUTH_CRUMB}" --user "$${USERNAME}:$${PASSWORD}" http://localhost/jenkins/setupWizard/completeInstall)
  echo "Skipped install wizard"
}

restart_jenkins() {
  echo "Restarting Jenkins"
  /opt/bitnami/ctlscript.sh restart

  until $(curl --output /dev/null --silent --head --fail http://localhost/jenkins/login); do
    printf '.'
    sleep 1
  done

  echo ""
  echo "Jenkins is back online"
}

install_jenkins_plugins() {
  echo "Installing plugins"

  /opt/bitnami/java/bin/java -jar /tmp/jenkins-cli.jar -ssh -i /root/.ssh/id_rsa -s http://127.0.0.1/jenkins/ -user user install-plugin swarm google-compute-engine google-storage-plugin

  restart_jenkins
}

install_gce_credentials() {
  echo "Configuring GCE credentials"

  /bin/cat <<EOF >/tmp/gce_credential.xml
<com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentials plugin="google-oauth-plugin@0.6">
  <module class="com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentialsModule"/>
  <projectId>${jenkins_workers_project_id}</projectId>
</com.google.jenkins.plugins.credentials.oauth.GoogleRobotMetadataCredentials>
EOF
  cat /tmp/gce_credential.xml | /opt/bitnami/java/bin/java -jar /tmp/jenkins-cli.jar -i /root/.ssh/id_rsa -ssh -s http://127.0.0.1/jenkins/ -user user create-credentials-by-xml "SystemCredentialsProvider::SystemContextResolver::jenkins" "(global)"
  rm -rf /tmp/gce_credential.xml
}

install_gce_plugin_configuration() {
  echo "Configuring GCE plugin"

  jenkins_config_path=/opt/bitnami/apps/jenkins/jenkins_home/config.xml

  /bin/cat <<EOF >/tmp/add_cloud.py
import xml.etree.ElementTree as ET
import requests

private_ip = requests.get(
  "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip",
  headers={
    "Metadata-Flavor": "Google",
  }
).text

tree = ET.parse('$${jenkins_config_path}')
root = tree.getroot()
slave_agent_port = root.findall('slaveAgentPort')
if len(slave_agent_port) > 1:
  slave_agent_port.text = "0"
else:
  xml = "<slaveAgentPort>0</slaveAgentPort>"
  element = ET.fromstring(xml)
  root.append(element)

clouds = root.findall('clouds')[0]

cloudXML = '''
<com.google.jenkins.plugins.computeengine.ComputeEngineCloud plugin="google-compute-engine@1.0.5">
  <name>{project_id}</name>
  <instanceCap>{instance_cap}</instanceCap>
  <projectId>{project_id}</projectId>
  <credentialsId>{project_id}</credentialsId>
  <configurations>
    <com.google.jenkins.plugins.computeengine.InstanceConfiguration>
      <description>{description}</description>
      <namePrefix>{name_prefix}</namePrefix>
      <region>{region}</region>
      <zone>{zone}</zone>
      <machineType>{machine_type}</machineType>
      <numExecutorsStr>{num_executors}</numExecutorsStr>
      <startupScript>{startup_script}</startupScript>
      <preemptible>{preemptible}</preemptible>
      <minCpuPlatform>{min_cpu_platform}</minCpuPlatform>
      <labels>{labels}</labels>
      <runAsUser>{run_as_user}</runAsUser>
      <bootDiskType>{boot_disk_type}</bootDiskType>
      <bootDiskAutoDelete>true</bootDiskAutoDelete>
      <bootDiskSourceImageName>{boot_disk_source_image_name}</bootDiskSourceImageName>
      <bootDiskSourceImageProject>{boot_disk_source_image_project}</bootDiskSourceImageProject>
      <networkConfiguration class="com.google.jenkins.plugins.computeengine.AutofilledNetworkConfiguration">
        <network>{network}</network>
        <subnetwork>{subnetwork}</subnetwork>
      </networkConfiguration>
      <externalAddress>true</externalAddress>
      <useInternalAddress>false</useInternalAddress>
      <networkTags>{network_tags}</networkTags>
      <serviceAccountEmail>{service_account_email}</serviceAccountEmail>
      <mode>NORMAL</mode>
      <retentionTimeMinutesStr>{retention_time_minutes}</retentionTimeMinutesStr>
      <launchTimeoutSecondsStr>{launch_timeout_seconds}</launchTimeoutSecondsStr>
      <bootDiskSizeGbStr>{boot_disk_size_gb}</bootDiskSizeGbStr>
      <numExecutors>{num_executors}</numExecutors>
      <retentionTimeMinutes>{retention_time_minutes}</retentionTimeMinutes>
      <launchTimeoutSeconds>{launch_timeout_seconds}</launchTimeoutSeconds>
      <bootDiskSizeGb>{boot_disk_size_gb}</bootDiskSizeGb>
    </com.google.jenkins.plugins.computeengine.InstanceConfiguration>
  </configurations>
</com.google.jenkins.plugins.computeengine.ComputeEngineCloud>
'''.format(
    project_id="${jenkins_workers_project_id}",
    instance_cap=${jenkins_workers_instance_cap},
    description="${jenkins_workers_description}",
    name_prefix="${jenkins_workers_name_prefix}",
    region="${jenkins_workers_region}",
    zone="${jenkins_workers_zone}",
    machine_type="${jenkins_workers_machine_type}",
    startup_script="""${jenkins_workers_startup_script}""".replace("<PRIVATE_IP>", private_ip),
    preemptible="${jenkins_workers_preemptible}",
    min_cpu_platform="${jenkins_workers_min_cpu_platform}",
    labels="${jenkins_workers_labels}",
    run_as_user="${jenkins_workers_run_as_user}",
    boot_disk_type="${jenkins_workers_boot_disk_type}",
    boot_disk_auto_delete=True,
    boot_disk_source_image_name="${jenkins_workers_boot_disk_source_image}",
    boot_disk_source_image_project="${jenkins_workers_boot_disk_source_image_project}",
    network="${jenkins_workers_network}",
    subnetwork="${jenkins_workers_subnetwork}",
    external_address=True,
    use_internal_address=False,
    network_tags="${jenkins_workers_network_tags}",
    service_account_email="${jenkins_workers_service_account_email}",
    retention_time_minutes=${jenkins_workers_retention_time_minutes},
    launch_timeout_seconds=${jenkins_workers_launch_timeout_seconds},
    boot_disk_size_gb=${jenkins_workers_boot_disk_size_gb},
    num_executors=${jenkins_workers_num_executors},
)
cloud = ET.fromstring(cloudXML)
clouds.append(cloud)

tree.write('$${jenkins_config_path}')
EOF
  python /tmp/add_cloud.py
}

install_jenkins_jobs() {
  echo "Installing Jenkins jobs"

  /bin/cat <<EOF > /tmp/install_jobs.py
import base64
import jenkins
import json
import requests
import time

JOBS_ENCODED = "${jobs_as_b64_json}"
JOBS_JSON = base64.b64decode(JOBS_ENCODED)
JOBS = json.loads(JOBS_JSON.decode('utf-8'))

def install_job(server, job_name, job_manifest, attempt=0):
    try:
        response = server.create_job(job_name, job_manifest)
    except requests.exceptions.HTTPError as err:
        print(err)
        time.sleep(10)
        install_job(job_name, job_manifest, attempt+1)

server = jenkins.Jenkins('http://localhost/jenkins/', username='${jenkins_username}', password='${jenkins_password}')
for job in JOBS:
    install_job(server, job['name'], job['manifest'])
EOF
  python /tmp/install_jobs.py

  echo "Jenkins jobs installed"
}

touch_setup_complete_file() {
  touch /tmp/instance_setup_complete
}

echo "Configuring Jenkins"

enable_jenkins_cli
generate_ssh_key
install_ssh_key
install_system_dependencies
install_python_dependencies
skip_jenkins_install_wizard

download_jenkins_cli
install_jenkins_plugins

install_gce_credentials
install_gce_plugin_configuration
install_jenkins_jobs

uninstall_ssh_key
disable_jenkins_cli

touch_setup_complete_file

echo "software-status configuration: success"
