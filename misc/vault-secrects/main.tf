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

resource "vault_mount" "ssh" {
  path ="infra"
  type = "kv"
  options = {version = "2"}
  description = "Infra secrets"
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"

  data_json = <<EOT
  {
  "username" : "ec2-user",
  "password" : "DevOps321"
  }
  EOT
}

resource "vault_generic_secret" "roboshop-dev-cart" {
path = "${vault_mount.roboshop-dev.path}/cart"

data_json = <<EOT
{
"username" : "ec2-user"
"password" : "DevOps321"
}
EOT
}

resource "vault_mount" "roboshop-dev" {
  path = "roboshop-dev"
  type = "kv"
  options = {version = "2"}
  description = "Robo shop"
}