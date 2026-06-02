locals {
  aws_region = "ap-southeast-1"
  project    = "shermin-ho"
}

remote_state {
  backend = "s3"

  config = {
    bucket         = "${local.project}-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt      = true
    use_lockfile = true
    profile      = "shermin"
  }

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "shermin"

  default_tags {
    tags = {
      Project     = "${local.project}"
      ManagedBy   = "terragrunt"
    }
  }
}
EOF
}
