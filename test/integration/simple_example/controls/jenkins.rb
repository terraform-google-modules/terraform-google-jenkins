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

require 'nokogiri'

project_id = attribute('project_id')

control "jenkins" do
  title "Jenkins configuration"

  describe "Jenkins" do
    describe "GCE configuration" do
      let(:config_xml) { command("sudo cat /opt/bitnami/apps/jenkins/jenkins_home/config.xml").stdout }
      let(:config) { Nokogiri::XML(config_xml.to_s) }

      it "is configured for the correct project" do
        expect(config.at_xpath('//clouds/*/projectId').children[0].text).to eq project_id
      end

      it "sets the name of the configured credentials to the project id" do
        expect(config.at_xpath('//clouds/*/credentialsId').children[0].text).to eq project_id
      end

      it "sets the launch zone of workers to the correct zone" do
        expect(config.at_xpath('//clouds/*/configurations/*/zone').children[0].text).to end_with "/us-east4-c"
      end
    end
  end

  describe "example job" do

    let(:config_xml) { command("sudo cat /opt/bitnami/apps/jenkins/jenkins_home/jobs/testjob/config.xml").stdout }
    let(:config) { Nokogiri::XML(config_xml.to_s) }

    it "is configured" do
      expect(config).not_to eq nil
    end

    describe "builders" do
      let(:builders) { config.at_xpath('//builders/hudson.tasks.Shell/command') }

      it "exist" do
        expect(builders).not_to eq nil
      end

      it "only has one" do
        expect(builders.children.count).to eq 1
      end

      it "is configured correctly" do
        expect(builders.children.first.text).to match /hello world from testjob/
      end
    end

    describe "GCS publisher" do
      let(:publishers) { config.at_xpath('//publishers/com.google.jenkins.plugins.storage.GoogleCloudStorageUploader') }

      it "is configured" do
        expect(publishers.count).to eq 1
      end

      it "is configured to publish to the correct GCS project" do
        expect(publishers.at_xpath('//credentialsId').text).to eq project_id
      end
    end
  end
end
