output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}

output "api_gateway_invoke_url" {
  value = module.api_gateway.apigatewayv2_api_api_endpoint
}
