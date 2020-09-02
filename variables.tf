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

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "region" {
  description = "The region to deploy to"
}

variable "create_firewall_rules" {
  description = "If worker firewall rules should be created"
  default     = false
  type        = bool
}

variable "jenkins_instance_name" {
  description = "The name to assign to the Jenkins VM"
  default     = "jenkins"
}

variable "jenkins_instance_machine_type" {
  description = "The machine type to provision for Jenkins"
  default     = "n1-standard-4"
}

variable "jenkins_boot_disk_source_image" {
  description = "The name of the disk image to use as the boot disk for the Jenkins master"
  default     = "bitnami-jenkins-2-204-2-1-linux-debian-9-x86-64"
}

variable "jenkins_boot_disk_source_image_project" {
  description = "The project within which the disk image to use as the Jenkins master boot disk exists"
  default     = "bitnami-launchpad"
}

variable "jenkins_instance_zone" {
  description = "The zone to deploy the Jenkins VM in"
}

variable "jenkins_instance_network" {
  description = "The GCP network to deploy the Jenkins VM in. The firewall rules will be created in the project which hosts this network."
}

variable "jenkins_instance_subnetwork" {
  description = "The GCP subnetwork to deploy the Jenkins VM in"
}

variable "jenkins_instance_tags" {
  type        = list(string)
  description = "Tags to assign to the Jenkins VM"
  default     = []
}

variable "jenkins_instance_additional_metadata" {
  type        = map(string)
  description = "Additional instance metadata to assign to the Jenkins VM"
  default     = {}
}

variable "jenkins_initial_password" {
  description = "The initial password to protect Jenkins logins with. Defaults to a random 8-character alphanumeric string. This may not contain special characters."
  default     = ""
}

variable "jenkins_instance_access_cidrs" {
  type        = list(string)
  description = "CIDRs to allow to access Jenkins over HTTP(s)"
  default     = ["0.0.0.0/0"]
}

variable "jenkins_service_account_name" {
  description = "The name of the service account to create for Jenkins VM provisioning"
  default     = "jenkins"
}

variable "jenkins_service_account_display_name" {
  description = "The display name of the service account to create for Jenkins VM provisioning"
  default     = "Jenkins"
}

variable "jenkins_workers_project_id" {
  description = "The GCP project to deploy Jenkins workers within"
}

variable "jenkins_workers_instance_cap" {
  description = "The maximum number of GCE instances to create as Jenkins workers"
  default     = 1
}

variable "jenkins_workers_description" {
  description = "A description of the Jenkins worker cloud to show in Jenkins"
  default     = "Jenkins worker"
}

variable "jenkins_workers_name_prefix" {
  description = "A prefix for the Jenkins workers instance names"
  default     = "jenkins"
}

variable "jenkins_workers_region" {
  description = "The name of the region into which to deploy Jenkins workers"
}

variable "jenkins_workers_zone" {
  description = "The name of the zone into which to deploy Jenkins workers"
  default     = "us-east4-b"
}

variable "jenkins_workers_machine_type" {
  description = "The machine type to deploy Jenkins workers onto"
  default     = "n1-standard-1"
}

variable "jenkins_workers_startup_script" {
  description = "Any additional configuration to run on boot of Jenkins workers"
  default     = ""
}

variable "jenkins_workers_preemptible" {
  description = "Whether to launch Jenkins workers as preemptible instances"
  default     = "false"
}

variable "jenkins_workers_min_cpu_platform" {
  description = "The [minimum CPU platform](https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform) to deploy Jenkins workers onto. Leave blank for no restriction."
  default     = ""
}

variable "jenkins_workers_labels" {
  type        = list(string)
  description = "GCP labels to apply to Jankins workers"
  default     = []
}

variable "jenkins_workers_run_as_user" {
  description = "The user to run Jenkins jobs as on workers"
  default     = "ubuntu"
}

variable "jenkins_workers_boot_disk_type" {
  description = "The boot disk type to associate with Jenkins workers. Valid options are 'local-ssd', 'pd-ssd', and 'pd-standard'"
  default     = "pd-ssd"
}

variable "jenkins_workers_boot_disk_source_image" {
  description = "The fully qualified URL to the disk image to use as the boot disk for Jenkins workers"
  default     = "ubuntu-1604-xenial-v20181023"
}

variable "jenkins_workers_boot_disk_source_image_project" {
  description = "The project within which the disk image to use as the Jenkins worker boot disk exists"
  default     = "ubuntu-os-cloud"
}

variable "jenkins_workers_network" {
  description = "The URL of the network to deploy Jenkins workers into"
}

variable "jenkins_workers_subnetwork" {
  description = "The name of the subnetwork to deploy Jenkins workers into"
  default     = "default"
}

variable "jenkins_workers_network_tags" {
  type        = list(string)
  description = "A list of network tags to apply to Jenkins workers"
  default     = ["jenkins-agent"]
}

variable "jenkins_workers_service_account_email" {
  description = "The service account email to assign to Jenkins workers. Leave blank for the default compute service account"
  default     = ""
}

variable "jenkins_workers_retention_time_minutes" {
  description = "The number of minutes for Jenkins workers to remain online after completing their last job"
  default     = "6"
}

variable "jenkins_workers_launch_timeout_seconds" {
  description = "The number of seconds to wait for a Jenkins worker to come online before timing out"
  default     = "300"
}

variable "jenkins_workers_boot_disk_size_gb" {
  description = "The size of Jenkins worker boot disks, in gigabytes"
  default     = "10"
}

variable "jenkins_workers_num_executors" {
  description = "The number of concurrent jobs that can run on each Jenkins worker"
  default     = 1
}

variable "gcs_bucket" {
  description = "The name of an existing GCS bucket to associate with the created service account, allowing build artifacts to be uploaded. Leave blank to skip"
  default     = ""
}

variable "jenkins_jobs" {
  description = "A list of Jenkins jobs to configure on the instance"
  default     = []
}

variable "jenkins_network_project_id" {
  description = "The project ID of the Jenkins network"
  default     = ""
}
