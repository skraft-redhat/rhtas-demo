#!/bin/bash

export POLICY_CONFIGURATION=git::github.com/redhat-gpe/config//default

ec validate image --image $IMAGE --verbose --policy $POLICY_CONFIGURATION --public-key cosign.pub --strict=false --show-successes --output yaml=report.yaml --output data=data.yaml --output attestation=attestation.json --output json=report-json.yaml
