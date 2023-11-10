
#terraform apply -auto-approve

sam local invoke --hook-name terraform "pillow-lambda" -e event.json
