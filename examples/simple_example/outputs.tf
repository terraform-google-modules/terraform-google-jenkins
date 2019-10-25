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

output "jenkins_instance_name" {
  description = "The name of the Jenkins master in GCP"
  value       = module.jenkins-gce.jenkins_instance_name
}

output "jenkins_instance_zone" {
  description = "The name of the Jenkins zone in GCP"
  value       = module.jenkins-gce.jenkins_instance_zone
}

output "jenkins_instance_public_ip" {
  description = "The public IP address of the Jenkins master"
  value       = module.jenkins-gce.jenkins_instance_public_ip
}

output "jenkins_instance_initial_password" {
  sensitive   = true
  description = "The initial password for the `user` user on the Jenkins master"
  value       = module.jenkins-gce.jenkins_instance_initial_password
}

