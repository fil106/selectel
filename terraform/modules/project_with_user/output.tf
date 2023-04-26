output "project_id" {
  value = selectel_vpc_project_v2.project_1.id
}

output "project_name" {
  value = selectel_vpc_project_v2.project_1.name
}

output "user_id" {
  value = selectel_vpc_user_v2.user_1.id
}

output "user_name" {
  value = selectel_vpc_user_v2.user_1.name
}

output "role_id" {
  value = selectel_vpc_role_v2.role_1.id
}

output "user_password" {
  value     = random_password.user_1_password.result
  sensitive = true
}
