# Udacity Capstone

[![CircleCI](https://circleci.com/gh/gauravsinghverma/UdacityCapstone.svg?style=svg)](https://circleci.com/gh/gauravsinghverma/UdacityCapstone)

## Project Overview

It is Capstone Udacity project to demonstrate implemnting docker image and kubernetes using Circleci pipeline. In this project Circleci orbs has been used
  - circleci/kubernetes@0.11.2
  - circleci/aws-eks@1.0.3
---

## Setup the Environment

* Create a virtualenv and activate it
   ```
   python3 -m venv virtualenv
   . virtualenv/bin/activate
   ```
* Run `make install` to install the necessary dependencies
  ```
  pip install --upgrade pip &&\
	pip install -r requirements.txt &&\
	sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 &&\
	sudo chmod +x /bin/hadolint
  ```

## Lint the App `make lint`
  ```
  hadolint Dockerfile --ignore DL4000
	pylint --disable=R,C,W1203,W1202 app.py
  ```

## Creating the infrastructure using orbs circleci/aws-eks@1.0.3
  ```
  aws-eks/create-cluster:
        cluster-name: gsvcapstone
  ```

## Creating the deployment steps with aws-eks/python3 executor
  ```
  - kubernetes/install
  - aws-eks/update-kubeconfig-with-authenticator:
      cluster-name: << parameters.cluster-name >>
      install-kubectl: true
  - kubernetes/create-or-update-resource:
      get-rollout-status: true
      resource-file-path: appdeployment.yml
      resource-name: deployment/gsvcapstone
  ```
  
## Update the container image using `aws-eks/update-container-image`
  ```
  aws-eks/update-container-image:
    cluster-name: gsvcapstone
    container-image-updates: gsvcapstone=30011802/gsvcapstone
    post-steps:
        - kubernetes/delete-resource:
            resource-names: gsvcapstone
            resource-types: deployment
            wait: true
    record: true
    requires:
        - create-deployment
    resource-name: deployment/gsvcapstone
  ```

## Testing the cluster steps
  ```
  - kubernetes/install
  - aws-eks/update-kubeconfig-with-authenticator:
      cluster-name: << parameters.cluster-name >>
  - run:
      name: Test cluster
      command: |
        kubectl get svc
        kubectl get nodes
        kubectl get deployment
  ```
  
 ## References
 - https://circleci.com/developer/orbs/orb/circleci/kubernetes
 - https://circleci.com/developer/orbs/orb/circleci/aws-eks
