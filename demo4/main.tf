terraform {
  backend "s3" {
    bucket         = "reinvent-serverless-terraform"
    key            = "demo4/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "reinvent-serverless-terraform-lockdb"
  }
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = var.provider_role_arn
  }
}

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = var.api_name
  description   = var.api_description
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = [
      "content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"
    ]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_api_domain_name = false

  integrations = {
    "GET /" = {
      lambda_arn             = module.lambda.lambda_function_arn
      payload_format_version = "2.0"
    }
  }
}

module "lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 6.0"
  timeout       = 30
  source_path   = var.source_dir
  function_name = var.lambda_function_name
  handler       = "app.lambda_handler"
  runtime       = "python3.10"
  #  store_on_s3         = true
  #  s3_bucket           = var.bucket_name
  create_sam_metadata = true
  publish             = true
  environment_variables = {
    BUCKET_NAME = var.image_bucket
  }
  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = module.lambda.lambda_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
    ]
  })
}
