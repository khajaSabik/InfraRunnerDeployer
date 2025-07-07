variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "ami_id" {
  default = "ami-0c7217cdde317cfec"  
}

variable "instance_type" {
  default = "t2.medium"
}


variable "key_name" {
  default = "infra-runner-key"
}
