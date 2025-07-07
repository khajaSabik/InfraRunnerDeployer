output "ec2_public_ip" {
  value = aws_instance.github_runner.public_ip
}

output "ec2_id" {
  value = aws_instance.github_runner.id
}
