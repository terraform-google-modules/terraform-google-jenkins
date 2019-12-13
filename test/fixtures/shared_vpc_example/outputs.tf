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

output "project_id" {
  description = "The project ID that fixtures and examples were created in"
  value       = var.project_id
}

output "jenkins_instance_name" {
  description = "The name of the running Jenkins instance"
  value       = module.example.jenkins_instance_name
}

output "jenkins_instance_zone" {
  description = "The zone in which Jenkins is running"
  value       = module.example.jenkins_instance_zone
}

output "jenkins_instance_public_ip" {
  description = "The public IP of the Jenkins instance"
  value       = module.example.jenkins_instance_public_ip
}

output "jenkins_password" {
  sensitive = true
  value     = module.example.jenkins_instance_initial_password
}

output "svpc_host_project_id" {
  description = "The Shared VPC host project ID. In example the project the Jenkins network is hosted in"
  value       = var.svpc_host_project_id
}

output "svpc_network_name" {
  description = "The network in Shared VPC host account to deploy the Jenkins instance to"
  value       = var.svpc_network_name
}

output "svpc_subnetwork_name" {
  description = "The subnetwork name to deploy Jenkins to"
  value       = var.svpc_subnetwork_name
}
