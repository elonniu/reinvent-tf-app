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
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
