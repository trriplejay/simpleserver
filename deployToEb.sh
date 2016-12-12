#!/bin/bash

install_requirements() {
  sudo apt-get install -y jq tree
  pip install awscli
  aws --version
  pip install awsebcli==3.7.8
  eb --version
}

setup_env() {
  source IN/myAwsCredentials/integration.env

  export AWS_EB_APPLICATION_NAME="simple-eb-app" #application should already be created on aws
  export AWS_EB_ENVIRONMENT_NAME="simpleEbApp-env" #environment should already exist on aws
  export AWS_EB_REGION="us-west-2" #region that the app/env are in
  export AWS_EB_IMAGE_NAME=$(jq -r '.sourceName' IN/simple-image-eb/version.json)
  export AWS_EB_IMAGE_TAG=$(jq -r '.version.versionName' IN/simple-image-eb/version.json)
  export AWS_EB_VERSION_LABEL="shippable.$AWS_EB_ENVIRONMENT_NAME.$AWS_EB_IMAGE_TAG" #unique label

}

configure_aws() {
  aws configure set aws_access_key_id $aws_access_key_id
  aws configure set aws_secret_access_key $aws_secret_access_key
  aws configure set region us-west-2
}

deploy_to_eb() {
  export DOCKERRUN_PATH=IN/simple-repo-eb/gitRepo/
  pushd $DOCKERRUN_PATH

  mv Dockerrun.aws.json /tmp/Dockerrun.tmp
  cat /tmp/Dockerrun.tmp | sed 's/<IMAGE_NAME>/$AWS_EB_IMAGE_NAME/' | sed 's/<TAG>/$AWS_EB_IMAGE_TAG/' > Dockerrun.aws.json

  echo | eb init "$AWS_EB_APPLICATION_NAME" -r "$AWS_EB_REGION"
  eb use "$AWS_EB_ENVIRONMENT_NAME"

  git add -A
  eb deploy --staged -l $AWS_EB_VERSION_LABEL
  popd
}


install_requirements
setup_env
configure_aws
deploy_to_eb
