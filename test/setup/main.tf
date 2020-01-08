/**
 * Copyright 2019 Google LLC
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

resource "random_id" "folder_rand" {
  byte_length = 2
}

resource "google_folder" "ci_jenkins_folder" {
  display_name = "ci-jenkins-folder-${random_id.folder_rand.hex}"
  parent       = "folders/${replace(var.folder_id, "folders/", "")}"
}

// Create Shared VPC host and service projects to test shared vpc example.
module "jenkins_svpc_host_project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 3.0"
  name              = "ci-jenkins-svpc-host"
  random_project_id = true
  org_id            = var.org_id
  folder_id         = google_folder.ci_jenkins_folder.id
  billing_account   = var.billing_account

  auto_create_network = false

  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}

/* Create shared network and subnetwork and
enable the Shared VPC feature for a created project, assigning it as a Shared VPC host project. */
module "jenkins_network" {
  source          = "terraform-google-modules/network/google"
  version         = "~> 1.5.0"
  project_id      = module.jenkins_svpc_host_project.project_id
  network_name    = "jenkins-network-${random_id.folder_rand.hex}"
  shared_vpc_host = true

  subnets = [
    {
      subnet_name   = "jenkins-main-subnet-${random_id.folder_rand.hex}"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = "us-east4"
    },
  ]
  secondary_ranges = {}
}

// Create shared svpc service project and assign it to host project
module "project" {
  source              = "terraform-google-modules/project-factory/google//modules/shared_vpc"
  name                = "ci-jenkins"
  random_project_id   = true
  org_id              = var.org_id
  folder_id           = google_folder.ci_jenkins_folder.id
  billing_account     = var.billing_account
  shared_vpc          = module.jenkins_network.svpc_host_project_id
  auto_create_network = true

  activate_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
  ]
}
