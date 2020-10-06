output "security-group_id" {
  value = aws_security_group.sfia2-sg.id
}

output "rds-security-group_id" {
  value = aws_security_group.rds-sg.id
}