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


provider "google" {
  version = "~> 2.12.0"
}

locals {
  artifact_bucket = "${var.project_id}-svpcjenkins-artifacts"
}

module "artifacts" {
  source = "../../modules/artifact_storage"

  project_id  = var.project_id
  jobs_count  = 1
  bucket_name = local.artifact_bucket

  jobs = [
    {
      name = "testjob"

      builders = [
        <<EOF
<hudson.tasks.Shell>
  <command>echo &quot;hello world from testjob&quot;
  env &gt; build-log.txt</command>
</hudson.tasks.Shell>
EOF
      ]
    }
  ]
}


module "jenkins-gce" {
  source                               = "../../"
  project_id                           = var.project_id
  jenkins_network_project_id           = var.svpc_host_project_id
  region                               = "us-east4"
  jenkins_instance_zone                = "us-east4-c"
  gcs_bucket                           = local.artifact_bucket
  jenkins_instance_network             = var.svpc_network_name
  jenkins_instance_subnetwork          = var.svpc_subnetwork_name
  jenkins_workers_region               = "us-east4"
  jenkins_workers_project_id           = var.project_id
  jenkins_workers_zone                 = "us-east4-c"
  jenkins_workers_machine_type         = "n1-standard-1"
  jenkins_workers_boot_disk_type       = "pd-ssd"
  jenkins_workers_network_tags         = ["jenkins-agent"]
  jenkins_workers_network              = var.svpc_network_name
  jenkins_workers_subnetwork           = var.svpc_subnetwork_name
  create_firewall_rules                = true
  jenkins_service_account_name         = "svpc-jenkins"
  jenkins_service_account_display_name = "SVPC Jenkins SA"

  jenkins_jobs = module.artifacts.jobs

}
