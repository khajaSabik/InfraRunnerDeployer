output "ec2_public_ip" {
  description = "Public IP of the GitHub runner instance"
  value       = aws_instance.github_runner.public_ip
}

output "ec2_id" {
  description = "EC2 instance ID"
  value       = aws_instance.github_runner.id
}

output "private_key_path" {
  description = "Private key file path to access EC2"
  value       = local_file.private_key.filename
}
