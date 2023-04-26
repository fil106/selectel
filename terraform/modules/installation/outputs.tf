output "vm_fip" {
  value = openstack_compute_floatingip_associate_v2.fip_tf.floating_ip
}

output "vm_password" {
  value     = random_password.random_password.result
  sensitive = true
}
