mock_provider "aws" {}

run "when_var_ami_is_null_then_using_default_ami" {
  variables {
    ami = null
    instance_type = "t2.micro"
    subnet_id = "test-subnet-id"
  }

  assert {
    condition     = alltrue([length(data.aws_ami.amzn-linux-2023-ami) == 1])
    error_message = "image_type: ${data.aws_ami.amzn-linux-2023-ami[0].image_type}"
  }
}
