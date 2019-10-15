#!/usr/bin/env bash

set -e
source PLUGIN_VERSIONS.sh

# Install yq yaml parser
wget https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
sudo chmod +x yq_linux_amd64
sudo mv yq_linux_amd64 /usr/local/bin/yq

# Modify splunk environment values
yq w -i .circleci/sck_values.yml global.splunk.hec.host $SPLUNK_HEC_HOST
yq w -i .circleci/sck_values.yml global.splunk.hec.token $SPLUNK_HEC_TOKEN
yq w -i .circleci/performance/perf_test_sck_values.yml global.splunk.hec.host $SPLUNK_HEC_HOST_PERF
yq w -i .circleci/performance/perf_test_sck_values.yml global.splunk.hec.token $SPLUNK_HEC_TOKEN_PERF

# # Pull docker images locally
# aws ecr get-login --region $AWS_REGION --no-include-email | bash
# docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-1.amazonaws.com/k8s-ci-logging:latest | awk 'END{print}' | sed -E 's/[0-9]+.dkr/$AWS_ACCOUNT_ID/g'
# docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-1.amazonaws.com/k8s-ci-metrics:latest | awk 'END{print}' | sed -E 's/[0-9]+.dkr/$AWS_ACCOUNT_ID/g'
# docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-1.amazonaws.com/k8s-ci-metrics-agg:latest | awk 'END{print}' | sed -E 's/[0-9]+.dkr/$AWS_ACCOUNT_ID/g'
# docker pull $AWS_ACCOUNT_ID.dkr.ecr.us-west-1.amazonaws.com/k8s-ci-objects:latest | awk 'END{print}' | sed -E 's/[0-9]+.dkr/$AWS_ACCOUNT_ID/g'

# Modify docker images to be used
image_name=splunk/fluentd-hec:$FLUENTD_HEC_VERSION
yq w -i .circleci/sck_values.yml splunk-kubernetes-logging.image.name $image_name
yq w -i .circleci/performance/perf_test_sck_values.yml splunk-kubernetes-logging.image.name $image_name

image_name=splunk/k8s-metrics:$K8S_METRICS_VERISION
yq w -i .circleci/sck_values.yml splunk-kubernetes-metrics.image.name $image_name
yq w -i .circleci/performance/perf_test_sck_values.yml splunk-kubernetes-metrics.image.name $image_name

image_name=splunk/k8s-metrics-aggr:$K8S_METRICS_AGGR_VERSION
yq w -i .circleci/sck_values.yml splunk-kubernetes-metrics.imageAgg.name $image_name
yq w -i .circleci/performance/perf_test_sck_values.yml splunk-kubernetes-metrics.imageAgg.name $image_name

image_name=splunk/kube-objects:$KUBE_OBJECT_VERSION
yq w -i .circleci/sck_values.yml splunk-kubernetes-objects.image.name $image_name
yq w -i .circleci/performance/perf_test_sck_values.yml splunk-kubernetes-objects.image.name $image_name