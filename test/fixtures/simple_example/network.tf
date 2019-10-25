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
  example_name = "simple-example"
}

resource "random_string" "suffix" {
  length  = 4
  special = "false"
  upper   = "false"
}

provider "google" {
  project = var.project_id
}

resource "google_compute_network" "main" {
  name                    = "cft-jenkins-test-${local.example_name}-${random_string.suffix.result}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "cft-jenkins-test-${local.example_name}-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/21"
  region        = var.region
  network       = google_compute_network.main.self_link
}

resource "google_compute_firewall" "ssh" {
  name    = "cft-jenkins-test-${local.example_name}-ssh-access"
  network = google_compute_network.main.self_link
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

