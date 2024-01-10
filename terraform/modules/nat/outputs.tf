output "router_id" {
  value = openstack_networking_router_v2.router_tf.id
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.subnet_tf.id
}

output "network_id" {
  value = openstack_networking_network_v2.network_tf.id
}