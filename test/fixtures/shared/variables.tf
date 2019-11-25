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
  description = "The GCP project ID to run tests in"
}

variable "region" {
  description = "The GCP region to run tests in"
  default     = "us-east4"
}

variable "jenkins_instance_zone" {
  description = "The zone to deploy the Jenkins VM in"
  default     = "us-east4-b"
}

variable "jenkins_workers_zone" {
  description = "The name of the zone into which to deploy Jenkins workers"
  default     = "us-east4-c"
}
