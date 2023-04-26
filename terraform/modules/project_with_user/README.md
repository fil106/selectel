## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.3.2 |
| <a name="requirement_selectel"></a> [selectel](#requirement\_selectel) | 3.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.3.2 |
| <a name="provider_selectel"></a> [selectel](#provider\_selectel) | 3.9.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.user_1_password](https://registry.terraform.io/providers/hashicorp/random/3.3.2/docs/resources/password) | resource |
| [selectel_vpc_project_v2.project_1](https://registry.terraform.io/providers/selectel/selectel/3.9.1/docs/resources/vpc_project_v2) | resource |
| [selectel_vpc_role_v2.role_1](https://registry.terraform.io/providers/selectel/selectel/3.9.1/docs/resources/vpc_role_v2) | resource |
| [selectel_vpc_user_v2.user_1](https://registry.terraform.io/providers/selectel/selectel/3.9.1/docs/resources/vpc_user_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | n/a |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | n/a |
| <a name="output_user_id"></a> [user\_id](#output\_user\_id) | n/a |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | n/a |
| <a name="output_user_password"></a> [user\_password](#output\_user\_password) | n/a |
