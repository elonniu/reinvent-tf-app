module "lambda" {
  source              = "terraform-aws-modules/lambda/aws"
  version             = "~> 6.0"
  timeout             = 300
  source_path         = var.source_dir
  function_name       = var.lambda_function_name
  handler             = "app.lambda_handler"
  runtime             = "python3.10"
  create_sam_metadata = true
  publish             = true
  allowed_triggers    = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
    }
  }
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
