terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25"
    }
  }
  required_version = ">= 1.6.3"
}

provider "aws" {
  region                   = var.aws_region
  shared_config_files      = [var.config_location]
  shared_credentials_files = [var.creds_location]
  profile                  = var.profile
}

# HTTP API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = var.api_name
  protocol_type = "HTTP"
}

# Integration between the HTTP API and the Lambda function
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda.invoke_arn
}

# Default route that triggers the Lambda integration
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Deploy the API
resource "aws_apigatewayv2_stage" "example_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

# Lambda permission to allow the API Gateway to invoke it
resource "aws_lambda_permission" "api_gw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_iam_role" "lambda_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  filename      = var.path_to_zip_file
  function_name = var.lambda_function_name
  handler       = "app.lambda_handler"
  description   = var.lambda_function_description
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.10"
}

resource "aws_iam_role_policy" "test_lambda_policy" {
  role   = aws_iam_role.lambda_role.name
  policy = jsonencode({
    Version   = "2012-10-17"
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

resource "aws_lambda_permission" "LambdaPermission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
