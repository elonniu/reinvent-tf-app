output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "lambda_function_console_url" {
  value = "https://console.aws.amazon.com/lambda/home?region=${var.aws_region}#/functions/${aws_lambda_function.lambda.function_name}"
}
