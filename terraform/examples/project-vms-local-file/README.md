## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | 1.49.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |
| <a name="requirement_selectel"></a> [selectel](#requirement\_selectel) | 3.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_installation-tesla-a2"></a> [installation-tesla-a2](#module\_installation-tesla-a2) | ./modules/installation | n/a |
| <a name="module_installation-tesla-t4-16g"></a> [installation-tesla-t4-16g](#module\_installation-tesla-t4-16g) | ./modules/installation | n/a |
| <a name="module_project"></a> [project](#module\_project) | ./modules/project_with_user | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.vars](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth"></a> [auth](#input\_auth) | URI до openstack api | `string` | `"https://api.selvpc.ru/identity/v3"` | no |
| <a name="input_az_zone"></a> [az\_zone](#input\_az\_zone) | Сегмент пула | `string` | `"ru-3b"` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Значение SSH-ключа для доступа к облачному серверу | `string` | `"key_value"` | no |
| <a name="input_region"></a> [region](#input\_region) | Пул Облачной платформы | `string` | `"ru-3"` | no |
| <a name="input_sel_token"></a> [sel\_token](#input\_sel\_token) | Selectel token для провайдереа selectel | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | CIDR подсети | `string` | `"10.10.0.0/24"` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Тип сетевого диска, из которого создается сервер | `string` | `"fast.ru-3b"` | no |

## Outputs

No outputs.
