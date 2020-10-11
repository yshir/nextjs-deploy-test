#!/bin/bash

set -e

S3_REGION="ap-northeast-1"
S3_BUCKET_NAME="nextjs-deploy-test--serverless-state"
S3_BUCKET_EXISTS=true
S3_PATH="s3://${S3_BUCKET_NAME}/prod/.serverless"
CLIENT_PATH=".serverless"

echo "====== run ======"

echo "[INFO] Download .serverless state from s3..."
if ! aws s3 sync "$S3_PATH" "$CLIENT_PATH" --delete --quiet 2>/dev/null; then
  echo "[WARNING] The specified bucket does not exist, Download failed."
  S3_BUCKET_EXISTS=false
fi
echo "[INFO] Download done"

echo "[INFO] Deploy started..."
serverless
echo "[INFO] Deploy done"

if ! $S3_BUCKET_EXISTS; then
  echo "[INFO] Create new s3 bucket..."
  aws s3api create-bucket \
    --bucket "$S3_BUCKET_NAME" \
    --region $S3_REGION \
    --create-bucket-configuration LocationConstraint=$S3_REGION
  echo "[INFO] Create done"
fi

echo "[INFO] Upload .serverless state to s3..."
aws s3 sync "$CLIENT_PATH" "$S3_PATH" --quiet --delete
echo "[INFO] Upload done"

echo "====== done ======"
