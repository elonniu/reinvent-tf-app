# Building Serverless Applications with Terraform based on Zip

This demo shows how to build a serverless application with Terraform based on a zip file.

## Prerequisites

You need to create a bucket and store the jpeg file `reinvent2023/test.jpeg` in it.
The bucket name is used in the Terraform configuration file.

## 1. Build the app.zip

```bash
./build.sh
```

## 2. Deploy the app.zip

```bash
terraform init
terraform apply
```
