# Поиск ID образа (из которого будет создан сервер) по его имени
data "openstack_images_image_v2" "ubuntu_image" {
  name        = var.image_name
  most_recent = true
  region      = var.region
}

# Запрос ID внешней сети по имени
data "openstack_networking_network_v2" "external_net" {
  name   = "external-network"
  region = var.region
}

# Создание роутера
resource "openstack_networking_router_v2" "router_tf" {
  name                = "router_tf_for_${var.vm_name}"
  external_network_id = data.openstack_networking_network_v2.external_net.id
  region              = var.region
}

# Создание сети
resource "openstack_networking_network_v2" "network_tf" {
  name   = "network_tf_for_${var.vm_name}"
  region = var.region
}

# Создание подсети
resource "openstack_networking_subnet_v2" "subnet_tf" {
  network_id = openstack_networking_network_v2.network_tf.id
  name       = "subnet_tf_for_${var.vm_name}"
  cidr       = var.subnet_cidr
  region     = var.region
}

# Подключение роутера к подсети
resource "openstack_networking_router_interface_v2" "router_interface_tf" {
  router_id = openstack_networking_router_v2.router_tf.id
  subnet_id = openstack_networking_subnet_v2.subnet_tf.id
  region    = var.region
}

# Создание уникального пароля
resource "random_password" "random_password" {
  length  = 16
  special = false
}

data "openstack_compute_flavor_v2" "flavor" {
  name   = var.flavor_name
  region = var.region
}

# Создание сетевого загрузочного диска размером 5 ГБ из образа
resource "openstack_blockstorage_volume_v3" "volume_server" {
  region               = var.region
  name                 = "volume-for_${var.vm_name}"
  size                 = var.volume_size
  image_id             = data.openstack_images_image_v2.ubuntu_image.id
  volume_type          = "${var.volume_type}.${var.az_zone}"
  availability_zone    = var.az_zone
  enable_online_resize = true
  lifecycle {
    ignore_changes = [image_id]
  }
}

# Создание сервера
resource "openstack_compute_instance_v2" "server_tf" {
  name              = var.vm_name
  flavor_id         = data.openstack_compute_flavor_v2.flavor.id
  availability_zone = var.az_zone
  # Изменяем пароль для root пользователя
  user_data = <<-EOT
#cloud-config
chpasswd:
  list: |
     root:${random_password.random_password.result}
  expire: False
  EOT
  region    = var.region
  network {
    uuid = openstack_networking_network_v2.network_tf.id
  }
  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_server.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }
  vendor_options {
    ignore_resize_confirmation = true
  }
  lifecycle {
    ignore_changes = [image_id]
  }
}

# Создание публичного IP-адреса
resource "openstack_networking_floatingip_v2" "fip_tf" {
  pool   = "external-network"
  region = var.region
}

# Привязка публичного IP-адреса к серверу
resource "openstack_compute_floatingip_associate_v2" "fip_tf" {
  floating_ip = openstack_networking_floatingip_v2.fip_tf.address
  instance_id = openstack_compute_instance_v2.server_tf.id
  region      = var.region
}