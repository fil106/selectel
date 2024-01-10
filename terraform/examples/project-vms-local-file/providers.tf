# Инициализация провайдера Selectel
provider "selectel" {
  token = var.sel_token
}

# Инициализация провайдера OpenStack
provider "openstack" {
  domain_name = local.domain_id
  auth_url    = var.auth
  tenant_id   = module.project.project_id
  user_name   = module.project.user_name
  password    = module.project.user_password
}
