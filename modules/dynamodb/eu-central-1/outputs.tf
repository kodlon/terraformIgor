output "dynamp_db_arn" {
  value = aws_dynamodb_table.this.arn
}

output "dynamp_db_name" {
  value = aws_dynamodb_table.this.name
}