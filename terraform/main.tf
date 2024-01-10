locals {
  # Получаем из sel_token domain_id для провайдера openstack
  domain_id = replace(regex("_[0-9]+$", var.sel_token), "_", "")
  # Формируем список из массива виртуалок для выгрузки в файл
  list = join("\n",
    [for i in module.installation-a2000-6gb-16gb : "${i.vm_fip} = ${i.vm_password}"]
    #[for i in module.installation-tesla-a2 : "${i.vm_fip} = ${i.vm_password}"]
  )
}

## Создание проекта и сервисного пользователя
module "project" {
  source = "./modules/project_with_user"

  project_name = "Project-tf"
  user_name    = "terraform_user_1"
}

module "nat" {
  source      = "./modules/nat"
  os_region   = "ru-7"
  subnet_cidr = var.subnet_cidr

  depends_on = [
    module.project
  ]
}

# Создание полноценной инсталляции виртуалка,роутер,сеть,плавающий ip
module "installation-a2000-6gb-16gb" {
  source     = "./modules/installation"
  region     = "ru-7"
  az_zone    = "ru-7a"
  router_id  = module.nat.router_id
  network_id = module.nat.network_id
  subnet_id  = module.nat.subnet_id

  count = 1 # Кол-во инсталляций

  vm_name     = "hakaton-${count.index + 1}"
  flavor_name = "GL8.8-65536-0-1GPU" # A2000-6GB RAM-64GB vCPU-8
  volume_size = "150"
  image_name  = "Ubuntu 22.04 LTS Machine Learning 64-bit"

  depends_on = [
    module.project
  ]
}

# Создание полноценной инсталляции виртуалка,роутер,сеть,плавающий ip
#module "installation-tesla-a2" {
#  source  = "./modules/installation"
#  region  = "ru-9"
#  az_zone = "ru-9a"
#
#  count = 1 # Кол-во инсталляций
#
#  vm_name     = "vm_${count.index}"
#  flavor_name = "GL5.24-196608-0-2GPU" # A2
#  volume_size = "30"
#  image_name  = "Ubuntu 18.04 LTS Machine Learning 64-bit"
#
#  depends_on = [
#    module.project
#  ]
#}

# можно создавать неограниченное количество модулей ...
# допустим для разных регионов или из разных образов

# Создание файла с ip=password
resource "local_file" "vars" {
  content  = local.list
  filename = "./vars.tfvars"
}
