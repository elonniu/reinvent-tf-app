output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.ApiDeployment.invoke_url
}
