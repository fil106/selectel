terraform {
  required_version = ">= 1.0.0"

  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = "3.9.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
}
