# Copyright 2018 Google LLC
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

ARG BASE_IMAGE

FROM $BASE_IMAGE

RUN apk add --no-cache \
        openssh-client

RUN cd /tmp && \
    wget https://releases.hashicorp.com/packer/1.3.3/packer_1.3.3_linux_amd64.zip && \
    unzip packer_1.3.3_linux_amd64.zip && \
    rm -rf packer_1.3.3_linux_amd64.zip && \
    mv packer $APP_BASE_DIR/bin/ && \
    packer --version

WORKDIR /opt/kitchen
COPY Gemfile .
RUN bundle install
WORKDIR $APP_BASE_DIR/workdir
