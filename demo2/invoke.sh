rm -rf builds
rm -rf .aws-sam-iacs
rm -rf .terraform
rm -rf .terraform.lock.hcl

sam local invoke --hook-name terraform "pillow-lambda" -e event.json
