#!/bin/bash


ec validate image --image $IMAGE --verbose --public-key cosign.pub --rekor-url $COSIGN_REKOR_URL --strict=false --show-successes --output yaml=report.yaml --output data=data.yaml --output attestation=attestation.json --output json=report-json.yaml
