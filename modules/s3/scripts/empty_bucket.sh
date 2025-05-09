bucket_name=$1
if ! aws s3api head-bucket --bucket $bucket_name; then
  echo "bucket is not exist"
  exit 1
fi

echo "bucket is exist"
aws s3 rm s3://$bucket_name
