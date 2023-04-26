locals {
  # Получаем из sel_token domain_id для провайдера openstack
  domain_id = replace(regex("_[0-9]+$", var.sel_token), "_", "")
  # Формируем список из массива виртуалок
  list      = join("\n", [for i in module.installation : "${i.vm_fip} = ${i.vm_password}"])
}

# Создание проекта и сервисного пользователя
module "project" {
  source = "./modules/project_with_user"

  project_name = "Project-tf"
  user_name    = "terraform_user"
}

# Создание полноценной инсталляции виртуалка,роутер,сеть,плавающий ip
module "installation" {
  source = "./modules/installation"

  count = 3

  vm_name    = "vm_${count.index}"
  image_name = "Ubuntu 20.04 LTS 64-bit"

  depends_on = [
    module.project
  ]
}

# Создание файла с ip=password
resource "local_file" "vars" {
  content  = local.list
  filename = "./vars.tfvars"
}