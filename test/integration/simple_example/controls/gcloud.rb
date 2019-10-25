# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
jenkins_instance_zone = attribute('jenkins_instance_zone')
jenkins_instance_name = attribute('jenkins_instance_name')

control "gcloud" do
  title "Google Compute Engine Jenkins configuration"

  describe google_compute_instance(project: project_id, zone: jenkins_instance_zone, name: jenkins_instance_name) do
    it { should exist }
    its('machine_type') { should end_with "n1-standard-4" }
    its('status') { should eq 'RUNNING' }
  end

  describe google_compute_firewall(project: project_id, name: "jenkins-#{jenkins_instance_name}-external-tcp-80") do
    it { should exist }
    its(:allowed_http?) { should be true }
    its(:direction) { should eq "INGRESS" }
    its(:source_ranges) { should eq ["0.0.0.0/0"] }
  end

  describe google_compute_firewall(project: project_id, name: "jenkins-#{jenkins_instance_name}-external-tcp-443") do
    it { should exist }
    its(:allowed_https?) { should be true }
    its(:direction) { should eq "INGRESS" }
    its(:source_ranges) { should eq ["0.0.0.0/0"] }
  end

  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/jenkins@#{project_id}.iam.gserviceaccount.com") do
    it { should exist }
    its(:display_name) { should eq "Jenkins" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/compute.instanceAdmin.v1") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/compute.instanceAdmin") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/compute.networkAdmin") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/compute.securityAdmin") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/iam.serviceAccountActor") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_project_iam_binding(project: project_id, role: "roles/iam.serviceAccountUser") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end

  describe google_storage_bucket_iam_binding(bucket: "#{project_id}-jenkins-artifacts", role: "roles/storage.admin") do
    it { should exist }
    its(:members) { should include "serviceAccount:jenkins@#{project_id}.iam.gserviceaccount.com" }
  end
end
