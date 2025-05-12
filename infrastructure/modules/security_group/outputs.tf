output "security_group_public_id" {
    value = aws_security_group.hnc_public_security_group.id
}

output "security_group_alb_public_id" {
    value = aws_security_group.hnc_alb_sg.id
}

