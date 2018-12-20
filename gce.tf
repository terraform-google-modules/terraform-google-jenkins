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
  jenkins_tags     = ["${var.jenkins_instance_network_tag}"]
  jenkins_username = "user"
  jenkins_password = "${coalesce(var.jenkins_initial_password, random_string.jenkins_password.result)}"

  jenkins_metadata = {
    bitnami-base-password  = "${local.jenkins_password}"
    status-uptime-deadline = 420
    startup-script         = "${data.template_file.jenkins_startup_script.rendered}"
  }
}

resource "random_string" "jenkins_password" {
  length  = 8
  special = false
}

data "google_compute_image" "jenkins" {
  name    = "bitnami-jenkins-2-138-2-0-linux-debian-9-x86-64"
  project = "bitnami-launchpad"
}

data "google_compute_image" "jenkins_worker" {
  name    = "${var.jenkins_workers_boot_disk_source_image}"
  project = "${var.jenkins_workers_boot_disk_source_image_project}"
}

resource "google_compute_instance" "jenkins" {
  project      = "${var.project_id}"
  name         = "${var.jenkins_instance_name}"
  machine_type = "${var.jenkins_instance_machine_type}"
  zone         = "${var.jenkins_instance_zone}"

  tags = "${concat(local.jenkins_tags, var.jenkins_instance_additional_tags)}"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.jenkins.self_link}"
    }
  }

  network_interface {
    subnetwork         = "${var.jenkins_instance_subnetwork}"
    subnetwork_project = "${var.project_id}"

    access_config {}
  }

  metadata = "${merge(local.jenkins_metadata, var.jenkins_instance_additional_metadata)}"

  service_account {
    email = "${google_service_account.jenkins.email}"

    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.full_control",
    ]
  }
}

resource "null_resource" "wait_for_jenkins_configuration" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/wait-for-jenkins.sh ${var.project_id} ${var.jenkins_instance_zone} ${var.jenkins_instance_name}"
  }

  depends_on = ["google_compute_instance.jenkins"]
}
