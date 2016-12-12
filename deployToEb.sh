#!/bin/bash

install_requirements() {
  sudo apt-get install -y jq tree
  pip install awscli
  pip install --upgrade --user awsebcli
}

configure_aws() {
  aws configure set aws_access_key_id $aws_access_key_id
  aws configure set aws_secret_access_key $aws_secret_access_key
  aws configure set region us-west-2
}

setup_env() {
  source IN/myAwsCredentials/integration.env

  export AWS_EB_APPLICATION_NAME="simple-eb-app"
  export AWS_EB_ENVIRONMENT_NAME="simpleEbApp-env"
  export AWS_EB_REGION="us-west-2"
  export AWS_EB_IMAGE_NAME=$(jq -r '.sourceName' IN/simple-image-eb/version.json) | sed -e 's/\//\\\//g')
  export AWS_EB_IMAGE_TAG=$(jq -r '.version.versionName' IN/simple-image-eb/version.json) | sed -e 's/\//\\\//g')
  export AWS_EB_VERSION_LABEL="shippable.$AWS_EB_ENVIRONMENT_NAME.$AWS_EB_IMAGE_TAG"

}

modify_dockerrun() {
  export DOCKERRUN_PATH=IN/simple-repo-eb/gitRepo/
  pushd $DOCKERRUN_PATH

  mv Dockerrun.aws.json /tmp/Dockerrun.tmp
  cat /tmp/Dockerrun.tmp | sed 's/<IMAGE_NAME>/$AWS_EB_IMAGE_NAME/' | sed 's/<TAG>/$AWS_EB_IMAGE_TAG/' > Dockerrun.aws.json

  popd
}

init_eb() {
  echo | eb init "$AWS_EB_APPLICATION_NAME" -r "$AWS_EB_REGION"
  eb use "$AWS_EB_ENVIRONMENT_NAME"
}

deploy_to_eb() {
  git add -A
  eb deploy --staged -l $AWS_EB_VERSION_LABEL
}


install_requirements
configure_aws
setup_env
modify_dockerrun
init_eb
deploy_to_eb
