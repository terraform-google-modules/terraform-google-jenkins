/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  jenkins_startup_script_template = "${file("${path.module}/templates/jenkins_startup_script.sh.tpl")}"

  jenkins_workers_agent_attach_script = <<EOF
#!/bin/bash
apt-get install -y -qq wget
cd /tmp
wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar
java -jar ./swarm-client-3.9.jar -username ${local.jenkins_username} -password ${local.jenkins_password} -master "http://<PRIVATE_IP>/jenkins/"
EOF

  jenkins_workers_startup_script = <<EOF
${local.jenkins_workers_agent_attach_script}
${var.jenkins_workers_startup_script}
EOF

  jenkins_workers_project_url = "https://www.googleapis.com/compute/v1/projects/${var.jenkins_workers_project_id}"
}

data "template_file" "jenkins_startup_script" {
  template = "${local.jenkins_startup_script_template}"

  vars {
    jenkins_username                               = "${local.jenkins_username}"
    jenkins_password                               = "${local.jenkins_password}"
    jenkins_workers_project_id                     = "${var.jenkins_workers_project_id}"
    jenkins_workers_instance_cap                   = "${var.jenkins_workers_instance_cap}"
    jenkins_workers_description                    = "${var.jenkins_workers_description}"
    jenkins_workers_name_prefix                    = "${var.jenkins_workers_name_prefix}"
    jenkins_workers_region                         = "${local.jenkins_workers_project_url}/regions/${var.jenkins_workers_region}"
    jenkins_workers_zone                           = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}"
    jenkins_workers_machine_type                   = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}/machineTypes/${var.jenkins_workers_machine_type}"
    jenkins_workers_startup_script                 = "${local.jenkins_workers_startup_script}"
    jenkins_workers_preemptible                    = "${var.jenkins_workers_preemptible ? "true" : "false"}"
    jenkins_workers_min_cpu_platform               = "${var.jenkins_workers_min_cpu_platform}"
    jenkins_workers_labels                         = "${join(",", var.jenkins_workers_labels)}"
    jenkins_workers_run_as_user                    = "${var.jenkins_workers_run_as_user}"
    jenkins_workers_boot_disk_type                 = "${local.jenkins_workers_project_url}/zones/${var.jenkins_workers_zone}/diskTypes/${var.jenkins_workers_boot_disk_type}"
    jenkins_workers_boot_disk_source_image         = "${data.google_compute_image.jenkins_worker.self_link}"
    jenkins_workers_boot_disk_source_image_project = "${var.jenkins_workers_boot_disk_source_image_project}"
    jenkins_workers_network                        = "${var.jenkins_workers_network}"
    jenkins_workers_subnetwork                     = "${var.jenkins_workers_subnetwork}"
    jenkins_workers_network_tags                   = "${join(",", var.jenkins_workers_network_tags)}"
    jenkins_workers_service_account_email          = "${var.jenkins_workers_service_account_email}"
    jenkins_workers_retention_time_minutes         = "${var.jenkins_workers_retention_time_minutes}"
    jenkins_workers_launch_timeout_seconds         = "${var.jenkins_workers_launch_timeout_seconds}"
    jenkins_workers_boot_disk_size_gb              = "${var.jenkins_workers_boot_disk_size_gb}"
    jenkins_workers_num_executors                  = "${var.jenkins_workers_num_executors}"
    jobs_as_b64_json                               = "${base64encode(jsonencode(var.jenkins_jobs))}"
  }
}
