provider "aws" {
    access_key = "##redacted##"
    secret_key = "##redacted##"
    region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 3
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/greet_lambda.py"
  output_path = "${path.module}/lambda_function.zip"
}


resource "aws_lambda_function" "udacity_lambda" {
  filename = "${path.module}/lambda_function.zip"
  function_name = "${var.lambda_function_name}"
  role = aws_iam_role.iam_for_lambda.arn
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  handler = "${var.lambda_function_name}.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      greeting = "Hellooo"
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda_log_group, aws_iam_role_policy_attachment.lambda_logs]
}