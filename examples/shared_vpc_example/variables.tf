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

variable "project_id" {
  description = "The project ID to deploy jenkins to"
}

variable "svpc_host_project_id" {
  description = "The Shared VPC host project ID. In example the project the Jenkins network is hosted in"
}

variable "svpc_network_name" {
  description = "The network in Shared VPC host account to deploy the Jenkins instance to"
}

variable "svpc_subnetwork_name" {
  description = "The subnetwork name to deploy Jenkins to"
}
