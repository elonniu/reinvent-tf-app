# Building Serverless Applications with Terraform based on Serverless.tf

This demo shows how to build a serverless application with Terraform based on [Serverless.tf](https://serverless.tf/)

## 1. Deploy

```bash
terraform init
terraform apply
```

## 2. Online Debugging

> If you not installed [Watchexec](https://github.com/watchexec/watchexec), please install it first.

```bash
watchexec -w ../src/app terraform apply --auto-approve
```

## 3. Local Debugging

> If you not installed [Watchexec](https://github.com/watchexec/watchexec), please install it first.

```bash
sam local start-api
```

Open new terminal window:

```bash
watchexec -w ../src/app sam build
```

