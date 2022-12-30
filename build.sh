#!/bin/bash

docker build \
    --build-arg APKMIRROR="mirrors.ustc.edu.cn" \
    -t wqsacy/php81-apline .
