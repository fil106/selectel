
# Создание сети
resource "openstack_networking_network_v2" "network_tf" {
  name   = "network"
  region = var.os_region
}

# Создание подсети
resource "openstack_networking_subnet_v2" "subnet_tf" {
  network_id = openstack_networking_network_v2.network_tf.id
  name       = "subnet"
  cidr       = var.subnet_cidr
  region     = var.os_region
}

# Запрос ID внешней сети по имени
data "openstack_networking_network_v2" "external_net" {
  name   = "external-network"
  region = var.os_region
}

# Создание роутера
resource "openstack_networking_router_v2" "router_tf" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.external_net.id
  region              = var.os_region
}

# Подключение роутера к подсети
resource "openstack_networking_router_interface_v2" "router_interface_tf" {
  router_id = openstack_networking_router_v2.router_tf.id
  subnet_id = openstack_networking_subnet_v2.subnet_tf.id
  region    = var.os_region
}
