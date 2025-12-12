#!/bin/bash

### --- System Update --- ###
apt-get update -y
apt-get upgrade -y

### --- Install Java 17 (required for Jenkins) --- ###
apt-get install -y openjdk-17-jdk

### --- Install Jenkins repository --- ###
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

### --- Start Jenkins --- ###
systemctl enable jenkins
systemctl start jenkins

### --- Install Terraform --- ###
apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | \
   gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | tee /etc/apt/sources.list.d/hashicorp.list

apt-get update -y
apt-get install -y terraform

### --- (Optional) Apache Install (remove if not needed) --- ###
apt-get install -y apache2
systemctl enable apache2
systemctl start apache2
