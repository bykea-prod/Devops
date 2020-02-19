#!/usr/bin/env bash

PATH="/data/jenkins/tools/com.cloudbees.jenkins.plugins.customtools.CustomTool/Terraform:$PATH"


terraform init
terraform plan -input=false -auto-approve
