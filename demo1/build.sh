# copy ../app to current directory

rm -rf app
rm -rf app.zip

cp -r ../app .
cd app

# install pip requirements in current directory
pip install -r requirements.txt -t .

# archive files in app to app.zip without app directory self
zip -r app.zip .

mv app.zip ../

cd ../

terraform init && terraform apply
