resource "aws_db_subnet_group" "main" {
  name       = "project-bedrock-db-subnet"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "rds" {
  name   = "project-bedrock-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# MySQL RDS
resource "aws_db_instance" "mysql" {
  identifier           = "bedrock-mysql"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "retailstore"
  username             = "admin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  multi_az             = false
  publicly_accessible  = false
  tags                 = var.tags
}

# PostgreSQL RDS
resource "aws_db_instance" "postgres" {
  identifier           = "bedrock-postgres"
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "retailstore"
  username             = "admin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot  = true
  multi_az             = false
  publicly_accessible  = false
  tags                 = var.tags
}

# Store credentials in Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "project-bedrock/db-credentials"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    mysql_host     = aws_db_instance.mysql.address
    mysql_user     = aws_db_instance.mysql.username
    mysql_password = var.db_password
    mysql_db       = aws_db_instance.mysql.db_name
    postgres_host  = aws_db_instance.postgres.address
    postgres_user  = aws_db_instance.postgres.username
    postgres_password = var.db_password
    postgres_db    = aws_db_instance.postgres.db_name
  })
}