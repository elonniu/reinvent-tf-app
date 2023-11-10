variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-west-2"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_function_description" {
  description = "The description of the Lambda function"
  type        = string
  default     = "Lambda function to resize images"
}

variable "lambda_handler" {
  description = "The function entrypoint in your code"
  type        = string
  default     = "app.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.10"
}

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "The description of the API Gateway"
  type        = string
  default     = "API linked to Lambda"
}

variable "api_stage_name" {
  description = "The stage name for the deployment of the API Gateway"
  type        = string
  default     = "prod"
}

variable "api_path_part" {
  description = "The path for the API Gateway"
  type        = string
  default     = "image"
}

variable "source_dir" {
  description = "Local path to the Lambda function code"
  type        = string
}

variable "path_to_zip_file" {
  description = "Local path to the zipped Lambda function code"
  type        = string
}
