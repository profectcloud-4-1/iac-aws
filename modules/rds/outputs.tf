output "credentials" {
  value = {
    endpoint = aws_db_instance.this.endpoint
    port     = aws_db_instance.this.port
    username = aws_db_instance.this.username
    password = aws_db_instance.this.password
    db_name  = aws_db_instance.this.db_name
  }
}