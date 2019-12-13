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

subnet_command = "gcloud compute networks subnets get-iam-policy #{svpc_subnetwork_name} --region #{region} --project=#{svpc_host_project_id} --format=json"

control "shared_vpc" do
  title "Check if SVPC set up correct and subnet has needed roles assigned to jenkins service-accounts"

  describe command(subnet_command) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "attached_to_subnet_policy_role" do
      it " equal compute.networkUser" do
        expect(data['bindings'][0]['role']).to eq 'roles/compute.networkUser'
      end
    end

    describe "policy members" do
      it " include jenkins service account" do
        expect(data['bindings'][0]['members']).to include "serviceAccount:#{jenkins_sa_name}@#{project_id}.iam.gserviceaccount.com"
      end
    end
  end


  describe command("gcloud compute shared-vpc get-host-project #{project_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "jenkins project" do
      it "should be a shared vpc service project for #{svpc_host_project_id}" do
        expect(data["name"]).to eq svpc_host_project_id
      end
    end
  end


    describe command("gcloud compute shared-vpc associated-projects list #{svpc_host_project_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "jenkins svpc host project" do
      it "should include #{project_id} as an associated service project" do
        expect(data).to include(
          {
            "id" => project_id,
            "type" => "PROJECT"
          }
        )
      end
    end
  end
end
