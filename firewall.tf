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

resource "google_compute_firewall" "jenkins-external-80" {
  name    = "jenkins-${var.jenkins_instance_name}-external-tcp-80"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}

resource "google_compute_firewall" "jenkins-external-443" {
  name    = "jenkins-${var.jenkins_instance_name}-external-tcp-443"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}


resource "google_compute_firewall" "jenkins-external-ssh" {
  name    = "jenkins-${var.jenkins_instance_name}-external-ssh"
  project = local.jenkins_network_project_id
  network = var.jenkins_instance_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges           = var.jenkins_instance_access_cidrs
  target_service_accounts = [google_service_account.jenkins.email]
}

resource "google_compute_firewall" "jenkins_agent_ssh_from_instance" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-ssh-access"
  network = var.jenkins_workers_network
  project = local.jenkins_network_project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = var.jenkins_instance_tags
  target_tags = var.jenkins_workers_network_tags
}

resource "google_compute_firewall" "jenkins_agent_discovery_from_agent" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-udp-discovery"
  network = var.jenkins_instance_network
  project = coalesce(var.jenkins_network_project_id, var.project_id)

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
  target_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
}

resource "google_compute_firewall" "jenkins_agent_discovery_from_agent_workers" {
  count = var.create_firewall_rules ? 1 : 0

  name    = "jenkins-agent-udp-discovery-workers"
  network = var.jenkins_workers_network
  project = coalesce(var.jenkins_network_project_id, var.project_id)

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
  target_tags = concat(var.jenkins_instance_tags, var.jenkins_workers_network_tags)
}
