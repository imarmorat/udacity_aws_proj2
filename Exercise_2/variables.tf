# TODO: Define the variable for aws_region
variable "lambda_function_name" {
  type        = string
  description = "The name of the lambda function for udacity exercise."
  default     = "greet_lambda"
}