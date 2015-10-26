#!/bin/bash -euo pipefail

build_parameters() {
  for k in "$@" ; do
    key=$(echo $k | cut -f1 -d=)
    value=${k#*$key=}
    printf "ParameterKey=%s,ParameterValue=%s " $key ${value//,/\\,}
  done
}

if [[ $# -lt 3 ]] ; then
  echo "usage: $0 [... Key=Val]"
  exit 1
fi

STACK_NAME=${STACK_NAME:-buildkite-$(date +%Y-%m-%d-%H-%M)}
STACK_TEMPLATE="$(dirname $0)/cloudformation.json"

cd $(dirname $0)
PARAMS=$(build_parameters "$@")

echo "Creating cfn stack ${STACK_NAME}"
aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --disable-rollback \
  --template-body "file://${STACK_TEMPLATE}" \
  --capabilities CAPABILITY_IAM \
  --parameters $PARAMS
