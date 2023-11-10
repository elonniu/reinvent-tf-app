#rm -rf builds
#sam build --hook-name terraform
sam local start-api --hook-name terraform --debug --port 3001

# run sam local start-api --hook-name terraform
# but if files changed in this directory, then restart sam local start-api --hook-name terraform
