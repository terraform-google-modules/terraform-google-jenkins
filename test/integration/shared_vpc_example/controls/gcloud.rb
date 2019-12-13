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
jenkins_sa_name = 'svpc-jenkins'
svpc_host_project_id = attribute('svpc_host_project_id')
svpc_network_name = attribute('svpc_network_name')
svpc_subnetwork_name = attribute('svpc_subnetwork_name')
region = "us-east4"


control "gcloud" do
  title "Google Compute Engine Jenkins configuration"

  describe google_compute_instance(project: project_id, zone: jenkins_instance_zone, name: jenkins_instance_name) do
    it { should exist }
    its('machine_type') { should end_with "n1-standard-4" }
    its('status') { should eq 'RUNNING' }
    let(:network_int)                { subject.network_interfaces[0].item }
    let(:network)                { network_int[:network] }
    let(:subnetwork)                { network_int[:subnetwork] }

    it "should be deployed to shared VPC network" do
      expect(network).to eq "https://www.googleapis.com/compute/v1/projects/#{svpc_host_project_id}/global/networks/#{svpc_network_name}"
    end

    it "should be deployed to expected svpc subnetwork" do
      expect(subnetwork).to eq "https://www.googleapis.com/compute/v1/projects/#{svpc_host_project_id}/regions/us-east4/subnetworks/#{svpc_subnetwork_name}"
    end
  end

end

