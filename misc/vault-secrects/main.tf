provider "vault" {
    address = "http://vault.kommanuthala.store:8200"
    token = var.vault_token
}

terraform {
  backend "s3" {
    bucket= "terraform-b86"
    key="vault-secrets/state"
    region="us-east-1"
  }
}

variable "vault_token" {}

data "vault_generic_secret" "secret_data" {
  path = "test/demo"
}

resource "local_file" "test" {
  filename = "/tmp/1"
  content = data.vault_generic_secret.secret_data.data["username"]
}

resource "vault_generic_secret" "ssh" {
  path = "infra/ssh"

  data_json = <<EOT
  {
  "username" = "ec2-user"
  "password" = "DevOps321"
  }
  EOT
}