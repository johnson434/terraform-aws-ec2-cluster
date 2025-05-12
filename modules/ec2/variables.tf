variable "ami" {
  type        = string
  description = "ec2 ami"
  nullable    = true
  default     = null
}

variable "instance_type" {
  type        = string
  description = "ec2 instance_type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "aws_instance subnet_id"
}

variable "user_data_base64" {
  type        = string
  description = "user_data encoded to base64"
  default     = "sudo yum update && sudo yum install -y nginx && sudo systemctl enable nginx.service && sudo systemctl start nginx.service"
}
