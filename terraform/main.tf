locals {
  # Получаем из sel_token domain_id для провайдера openstack
  domain_id = replace(regex("_[0-9]+$", var.sel_token), "_", "")
  # Формируем список из массива виртуалок для выгрузки в файл
  list = join("\n",
    [for i in module.installation-tesla-t4-16g : "${i.vm_fip} = ${i.vm_password}"],
    [for i in module.installation-tesla-a2 : "${i.vm_fip} = ${i.vm_password}"])
}

# Создание проекта и сервисного пользователя
module "project" {
  source = "./modules/project_with_user"

  project_name = "Project-tf"
  user_name    = "terraform_user"
}

# Создание полноценной инсталляции виртуалка,роутер,сеть,плавающий ip
module "installation-tesla-t4-16g" {
  source  = "./modules/installation"
  region  = "ru-7"
  az_zone = "ru-7a"

  count = 3 # Кол-во инсталляций

  vm_name     = "vm_${count.index}"
  flavor_name = "GL3.4-32768-0-1GPU" # Tesla T4
  volume_size = "30"
  image_name  = "Ubuntu 18.04 LTS Machine Learning 64-bit"

  depends_on = [
    module.project
  ]
}

# Создание полноценной инсталляции виртуалка,роутер,сеть,плавающий ip
module "installation-tesla-a2" {
  source  = "./modules/installation"
  region  = "ru-7"
  az_zone = "ru-7a"

  count = 1 # Кол-во инсталляций

  vm_name     = "vm_${count.index}"
  flavor_name = "GL5.24-196608-0-2GPU" # A2
  volume_size = "30"
  image_name  = "Ubuntu 18.04 LTS Machine Learning 64-bit"

  depends_on = [
    module.project
  ]
}

# Создание файла с ip=password
resource "local_file" "vars" {
  content  = local.list
  filename = "./vars.tfvars"
}