## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | 1.49.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 1.49.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [openstack_blockstorage_volume_v3.volume_server](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/blockstorage_volume_v3) | resource |
| [openstack_compute_flavor_v2.flavor_server](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/compute_flavor_v2) | resource |
| [openstack_compute_floatingip_associate_v2.fip_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/compute_floatingip_associate_v2) | resource |
| [openstack_compute_instance_v2.server_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/compute_instance_v2) | resource |
| [openstack_networking_floatingip_v2.fip_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/networking_floatingip_v2) | resource |
| [openstack_networking_network_v2.network_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/networking_network_v2) | resource |
| [openstack_networking_router_interface_v2.router_interface_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/networking_router_interface_v2) | resource |
| [openstack_networking_router_v2.router_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/networking_router_v2) | resource |
| [openstack_networking_subnet_v2.subnet_tf](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/resources/networking_subnet_v2) | resource |
| [random_password.random_password](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/password) | resource |
| [openstack_images_image_v2.ubuntu_image](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/data-sources/images_image_v2) | data source |
| [openstack_networking_network_v2.external_net](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0/docs/data-sources/networking_network_v2) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_zone"></a> [az\_zone](#input\_az\_zone) | Сегмент пула | `string` | `"ru-3b"` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Какой хотим образ для вм | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Пул Облачной платформы | `string` | `"ru-3"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR подсети | `string` | `"10.10.0.0/24"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | Кол-во инсталляций | `string` | n/a | yes |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Тип сетевого диска, из которого создается сервер | `string` | `"fast.ru-3b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_fip"></a> [vm\_fip](#output\_vm\_fip) | n/a |
| <a name="output_vm_password"></a> [vm\_password](#output\_vm\_password) | n/a |
