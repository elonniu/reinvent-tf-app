output "api_endpoint" {
  description = "Base url for api"
  value       = aws_api_gateway_stage.stage.invoke_url
}

output "http_api_logs_command" {
  description = "Command to view http api logs with sam"
  value       = "sam logs --cw-log-group ${aws_cloudwatch_log_group.logs.name} -t"
}

output "responder_logs_command" {
  description = "Command to view responder function logs with sam"
  value       = "sam logs --cw-log-group ${module.lambda_function_responder.lambda_cloudwatch_log_group_name} -t"
}
