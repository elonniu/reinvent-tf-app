output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "http_api_url" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "lambda_function_console_url" {
  value = "https://console.aws.amazon.com/lambda/home?region=${var.aws_region}#/functions/${aws_lambda_function.lambda.function_name}"
}
