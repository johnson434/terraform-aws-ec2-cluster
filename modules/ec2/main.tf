data "aws_ami" "amzn-linux-2023-ami" {
  count = var.ami == null ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "MyAWSResource" {
  ami           = var.ami == null ? data.aws_ami.amzn-linux-2023-ami[0].id : var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  user_data     = var.user_data_base64
}
