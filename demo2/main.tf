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

module "lambda" {
  source            = "terraform-aws-modules/lambda/aws"
  version           = "5.2.0"
  function_name     = var.lambda_function_name
  timeout           = 30
  description       = var.lambda_function_description
  handler           = var.lambda_handler
  source_path       = var.source_dir
  runtime           = "python3.10"
  policy_statements = [
    {
      actions   = ["s3:*"]
      resources = ["*"]
    },
  ]
}

resource "aws_iam_role_policy" "lambda_policy" {
  role   = module.lambda.lambda_role_name
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
  uri                     = module.lambda.lambda_function_invoke_arn
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
  function_name = module.lambda.lambda_role_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.RestAPI.execution_arn}/*/*"
}
