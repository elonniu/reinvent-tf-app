# Building Serverless Applications with Terraform based on Serverless.tf

This demo shows how to build a serverless application with Terraform based on [Serverless.tf](https://serverless.tf/)

## Prerequisites

You need to create a bucket and store the jpeg file `reinvent2023/test.jpeg` in it.
The bucket name is used in the Terraform configuration file.

## 1. Deploy

```bash
terraform init
terraform apply
```

## 2. Local Debugging

> If you are not installed [Watchexec](https://github.com/watchexec/watchexec), please install it first.

```bash
sam local start-api
```

Open new terminal window:

```bash
watchexec -w ./src sam build
```

## 3. Online Debugging

You can test your application on your AWS development account. Using File Watcher, you will be able to develop your lambda functions locally, and once you save your updates, terraform updates your development account with the updated Lambda functions. So, you can test it on cloud, and if there is any bug, you can quickly update the code.

> If you are not installed [Watchexec](https://github.com/watchexec/watchexec), please install it first.

```bash
watchexec -w ./src terraform apply --auto-approve
```
