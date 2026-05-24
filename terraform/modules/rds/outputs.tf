output "mysql_endpoint"    { value = aws_db_instance.mysql.address }
output "postgres_endpoint" { value = aws_db_instance.postgres.address }
output "secret_arn"        { value = aws_secretsmanager_secret.db_credentials.arn }