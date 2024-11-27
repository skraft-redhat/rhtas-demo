#!/bin/bash

skopeo copy docker://registry.access.redhat.com/ubi8/nginx-122:latest docker://$QUAY_URL/quayadmin/nginx:unsigned
