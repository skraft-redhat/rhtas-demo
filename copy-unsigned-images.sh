#!/bin/bash

export QUAY_URL=quay.io
export QUAY_ORGANIZATION=stephan_kraft

echo "Repo set to $QUAY_URL/$QUAY_ORGANIZATION"

skopeo copy docker://registry.access.redhat.com/ubi9/nginx-122@sha256:4d83750a3b60e625c17f679a6406b0ba4126267b16c1cf8f316ea76b24ef99b4 docker://$QUAY_URL/$QUAY_ORGANIZATION/nginx:9.5
skopeo copy docker://registry.access.redhat.com/ubi9/nginx-122@sha256:7b1bef263bc29e04215b0893b3a8d3b5b8148c9fbcdff755d7df7c1c0e9b5d59 docker://$QUAY_URL/$QUAY_ORGANIZATION/nginx:1-79
skopeo copy docker://registry.access.redhat.com/ubi9/nginx-122@sha256:7842d2e458038d2eb54068264c94a1f413d1114d1c4f717f19777f91d56b1a7a docker://$QUAY_URL/$QUAY_ORGANIZATION/nginx:1-69
