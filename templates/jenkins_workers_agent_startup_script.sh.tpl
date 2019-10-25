#!/bin/bash

apt-get install -y -qq wget
cd /tmp
wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/3.9/swarm-client-3.9.jar
java -jar ./swarm-client-3.9.jar -username ${jenkins_username} -password ${jenkins_password} -master "http://<PRIVATE_IP>/jenkins/"
