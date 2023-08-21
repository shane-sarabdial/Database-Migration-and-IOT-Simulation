output "test" {
  value = aws_lambda_function.lambda.role
}


output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}