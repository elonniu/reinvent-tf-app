module "lambda_function_responder" {
  source              = "terraform-aws-modules/lambda/aws"
  version             = "~> 6.0"
  timeout             = 300
  source_path         = "/home/ubuntu/IdeaProjects/reinvent2023/src/app/"
  function_name       = "responder"
  handler             = "app.lambda_handler"
  runtime             = "python3.9"
  create_sam_metadata = true
  publish             = true
  allowed_triggers    = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
    }
  }
}
