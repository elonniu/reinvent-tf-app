output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.ApiDeployment.invoke_url
}
