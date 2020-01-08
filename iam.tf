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


resource "google_service_account" "jenkins" {
  project      = var.project_id
  account_id   = var.jenkins_service_account_name
  display_name = var.jenkins_service_account_display_name
}

resource "google_project_iam_member" "jenkins-instance_admin_v1" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-security_admin" {
  project = var.project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-service_account_actor" {
  project = var.project_id
  role    = "roles/iam.serviceAccountActor"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_project_iam_member" "jenkins-service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.jenkins.email}"
}

resource "google_storage_bucket_iam_member" "jenkins-upload" {
  count  = var.gcs_bucket != "" ? 1 : 0
  bucket = var.gcs_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.jenkins.email}"
}

// SharedVPC requirements
locals {
  svpc_subnets_count = var.jenkins_instance_subnetwork != var.jenkins_workers_subnetwork ? 2 : 1
}

resource "google_compute_subnetwork_iam_member" "jenkins_svpc_subnets" {
  count      = var.jenkins_network_project_id != "" ? local.svpc_subnets_count : 0
  subnetwork = element([var.jenkins_instance_subnetwork, var.jenkins_workers_subnetwork], count.index)
  role       = "roles/compute.networkUser"
  region     = var.region
  project    = var.jenkins_network_project_id
  member     = "serviceAccount:${google_service_account.jenkins.email}"
}
