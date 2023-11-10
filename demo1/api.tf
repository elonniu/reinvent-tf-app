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
