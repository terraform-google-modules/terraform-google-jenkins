# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
region = attribute('region')
jenkins_instance_zone = attribute('jenkins_instance_zone')
jenkins_instance_name = attribute('jenkins_instance_name')

control "gcloud" do
  title "Google Compute Engine Jenkins configuration"

  describe google_compute_instance(project: project_id, zone: jenkins_instance_zone, name: jenkins_instance_name) do
    it { should exist }
    its('machine_type') { should end_with "n1-standard-4" }
    its('status') { should eq 'RUNNING' }
  end
end
