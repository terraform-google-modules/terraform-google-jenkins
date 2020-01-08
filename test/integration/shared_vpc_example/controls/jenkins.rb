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

server_ip = attribute('jenkins_instance_public_ip')
password = attribute('jenkins_password')

control "jenkins" do
  title "Jenkins HTTP check"
  describe http("http://#{server_ip}/jenkins/", auth: {user: 'user', pass: password}, open_timeout: 60, read_timeout: 60, ssl_verify: true, max_redirects: 3) do
    its('status') { should eq 200 }
    its('body') { should include 'Jenkins' }
    its('body') { should include 'testjob' }
    end
end
