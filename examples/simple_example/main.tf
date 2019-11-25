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
  region = var.region
}

locals {
  worker_network_project_id = coalesce(var.jenkins_network_project_id, var.project_id)
}

resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = "false"
}

resource "google_project_service" "iam" {
  project            = google_project_service.cloudresourcemanager.project
  service            = "iam.googleapis.com"
  disable_on_destroy = "false"
}

data "google_compute_image" "jenkins_agent" {
  project = google_project_service.cloudresourcemanager.project
  family  = "jenkins-agent"
}

resource "google_storage_bucket" "artifacts" {
  name          = "${var.project_id}-jenkins-artifacts"
  project       = var.project_id
  force_destroy = true
}

data "local_file" "example_job_template" {
  filename = "${path.module}/templates/example_job.xml.tpl"
}

data "template_file" "example_job" {
  template = data.local_file.example_job_template.content

  vars = {
    project_id            = var.project_id
    build_artifact_bucket = google_storage_bucket.artifacts.url
  }
}

resource "google_compute_firewall" "jenkins_agent_ssh_from_instance" {
  name    = "jenkins-agent-ssh-access"
  network = var.network
  project = local.worker_network_project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["jenkins"]
  target_tags = ["jenkins-agent"]
}

resource "google_compute_firewall" "jenkins_agent_discovery_from_agent" {
  name    = "jenkins-agent-udp-discovery"
  network = var.network
  project = local.worker_network_project_id

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags = ["jenkins", "jenkins-agent"]
  target_tags = ["jenkins", "jenkins-agent"]
}

module "jenkins-gce" {
  source                                         = "../../"
  project_id                                     = google_project_service.iam.project
  region                                         = var.region
  gcs_bucket                                     = google_storage_bucket.artifacts.name
  jenkins_instance_zone                          = var.jenkins_instance_zone
  jenkins_instance_network                       = var.network
  jenkins_instance_subnetwork                    = var.subnetwork
  jenkins_instance_additional_metadata           = var.jenkins_instance_metadata
  jenkins_workers_region                         = var.region
  jenkins_workers_project_id                     = google_project_service.iam.project
  jenkins_workers_zone                           = var.jenkins_workers_zone
  jenkins_workers_machine_type                   = "n1-standard-1"
  jenkins_workers_boot_disk_type                 = "pd-ssd"
  jenkins_workers_network                        = var.network
  jenkins_workers_network_tags                   = ["jenkins-agent"]
  jenkins_workers_boot_disk_source_image         = data.google_compute_image.jenkins_agent.name
  jenkins_workers_boot_disk_source_image_project = var.project_id

  jenkins_jobs = [
    {
      name     = "testjob"
      manifest = data.template_file.example_job.rendered
    },
  ]
}

