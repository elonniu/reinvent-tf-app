# Building Serverless Applications with Terraform based on Zip

## 1. Build the app.zip

```bash
./build.sh
```

## 2. Deploy the app.zip

```bash
terraform init
terraform apply
```

## 3. Live Development

```bash
sam local start-api
```

> Note: You need to run `sam build` if you change the code.
