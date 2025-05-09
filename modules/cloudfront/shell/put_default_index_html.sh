using_default_index_page=$1
bucket=$2
index_location=$3

if [[ $using_default_index_page == "false" ]]; then
	exit 0
else
	echo "default index page setting is true. try to put index.html to $bucket"
	aws s3api put-object --bucket $bucket --key index.html --content-type text/html --body $index_location
fi
