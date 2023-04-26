resource "selectel_vpc_project_v2" "project_1" {
  name = var.project_name
}

resource "random_password" "user_1_password" {
  length           = 16
  special          = true
  override_special = "!&*."
  min_special      = 1
  min_numeric      = 1
}

resource "selectel_vpc_user_v2" "user_1" {
  name     = var.user_name
  password = random_password.user_1_password.result
}

resource "selectel_vpc_role_v2" "role_1" {
  project_id = selectel_vpc_project_v2.project_1.id
  user_id    = selectel_vpc_user_v2.user_1.id
}
