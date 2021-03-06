### Get app name & image url ###

#!/bin/bash
echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"
echo "BUILD_NUMBER=${BUILD_NUMBER}"

# Learn more about the available environment variables at:
# https://cloud.ibm.com/docs/services/ContinuousDelivery?topic=ContinuousDelivery-deliverypipeline_environment#deliverypipeline_environment

# To review or change build options use:
# ibmcloud cr build --help

echo "go-do" > properties
echo "${REGISTRY_URL}/${REGISTRY_NAMESPACE}/${IMAGE_NAME}:${BUILD_NUMBER}" >> properties

input="properties"
N=0
while IFS= read -r line
do
  if [ $N == 0 ];then
    echo "IDS_PROJECT_NAME=$line"
    export "IDS_PROJECT_NAME=$line"
    N=1
  elif [ $N == 1 ]
  then
    echo "PIPELINE_IMAGE_URL=$line"
    export "PIPELINE_IMAGE_URL=$line"
  fi
done < "$input"

echo -e "Checking for Dockerfile at the repository root"
if [ -f Dockerfile ]; then 
   echo "Dockerfile found"
else
    echo "Dockerfile not found"
    exit 1
fi

echo -e "Building container image"
set -x
ibmcloud cr build -t $REGISTRY_URL/$REGISTRY_NAMESPACE/$IMAGE_NAME:$BUILD_NUMBER .
set +x
