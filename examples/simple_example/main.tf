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
  region  = var.region
  version = "~> 2.12.0"
}

locals {
  artifact_bucket = "${var.project_id}-jenkins-artifacts"
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

data "google_compute_image" "jenkins_agent" {
  project = var.project_id
  family  = "jenkins-agent"
}

module "jenkins-gce" {
  source                                         = "../../"
  project_id                                     = var.project_id
  region                                         = var.region
  jenkins_instance_zone                          = var.jenkins_instance_zone
  gcs_bucket                                     = local.artifact_bucket
  jenkins_instance_network                       = var.network
  jenkins_instance_subnetwork                    = var.subnetwork
  jenkins_instance_additional_metadata           = var.jenkins_instance_metadata
  jenkins_workers_region                         = var.region
  jenkins_workers_project_id                     = var.project_id
  jenkins_workers_zone                           = var.jenkins_workers_zone
  jenkins_workers_machine_type                   = "n1-standard-1"
  jenkins_workers_boot_disk_type                 = "pd-ssd"
  jenkins_workers_network                        = var.network
  jenkins_workers_network_tags                   = ["jenkins-agent"]
  jenkins_workers_boot_disk_source_image         = data.google_compute_image.jenkins_agent.name
  jenkins_workers_boot_disk_source_image_project = var.project_id
  jenkins_service_account_name                   = "jenkins"
  jenkins_service_account_display_name           = "Jenkins"
  create_firewall_rules                          = true

  jenkins_jobs = module.artifacts.jobs
}

