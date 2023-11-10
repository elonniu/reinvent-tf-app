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

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "The description of the API Gateway"
  type        = string
  default     = "API linked to Lambda"
}

variable "source_dir" {
  description = "Local path to the Lambda function code"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "config_location" {
  description = "AWS configuration file"
  type        = string
  default     = "~/.aws/config"
}

variable "creds_location" {
  description = "AWS credentials file"
  type        = string
  default     = "~/.aws/credentials"
}
