output "bucket_name"   { value = aws_s3_bucket.assets.bucket }
output "lambda_name"   { value = aws_lambda_function.processor.function_name }