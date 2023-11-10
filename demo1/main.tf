provider "aws" {
  region = var.aws_region
}

resource "aws_api_gateway_rest_api" "RestAPI" {
  name        = var.api_name
  description = var.api_description
}

resource "aws_api_gateway_resource" "ApiResource" {
  rest_api_id = aws_api_gateway_rest_api.RestAPI.id
  parent_id   = aws_api_gateway_rest_api.RestAPI.root_resource_id
  path_part   = var.api_path_part
}

resource "aws_api_gateway_method" "ApiMethod" {
  rest_api_id   = aws_api_gateway_rest_api.RestAPI.id
  resource_id   = aws_api_gateway_resource.ApiResource.id
  http_method   = "POST"
  authorization = "NONE"
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.path_to_zip_file
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
  filename         = var.path_to_zip_file
  function_name    = var.lambda_function_name
  handler          = var.lambda_handler
  description      = var.lambda_function_description
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  runtime          = "python3.10"
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

resource "aws_api_gateway_integration" "ApiIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.RestAPI.id
  resource_id             = aws_api_gateway_resource.ApiResource.id
  http_method             = aws_api_gateway_method.ApiMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "ApiDeployment" {
  depends_on = [
    aws_api_gateway_integration.ApiIntegration,
  ]

  rest_api_id = aws_api_gateway_rest_api.RestAPI.id
  stage_name  = var.api_stage_name
}

resource "aws_lambda_permission" "LambdaPermission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.RestAPI.execution_arn}/*/*"
}
