provider "aws" {
  region = "ap-northeast-2"
  default_tags {
    tags = {
      Environment = var.env
      Project     = var.project_name
    }
  }
}
