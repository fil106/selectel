# Инициализация Terraform и хранения Terraform State
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.49.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
    selectel = {
      source  = "selectel/selectel"
      version = "3.11.0"
    }
  }
}
