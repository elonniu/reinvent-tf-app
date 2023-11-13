# Building Serverless Applications with Terraform based on Serverless.tf

This demo shows how to build a serverless application with Terraform based on [Serverless.tf](https://serverless.tf/)

## 1. Deploy

```bash
terraform init
terraform apply
```

## 2. Live Development

```bash
sam local start-api
```

> Note: You need to run `sam build` if you change the code.
