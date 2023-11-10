output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.ApiDeployment.invoke_url
}

output "lambda_function_console_url" {
  value = "https://console.aws.amazon.com/lambda/home?region=${var.aws_region}#/functions/${aws_lambda_function.lambda.function_name}"
}

output "api_gateway_console_url" {
  value = "https://console.aws.amazon.com/apigateway/home?region=${var.aws_region}#/apis/${aws_api_gateway_rest_api.RestAPI.id}/resources/${aws_api_gateway_resource.ApiResource.id}/methods/POST"
}
