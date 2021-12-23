# terraform {
#   backend "azure" {}
# }
terraform {
  backend "local" {
  }
}

# terraform {
#   backend "remote" {
#     organization = "sparq"

#     workspaces {
#       name = "st-kvsas-test"
#     }
#   }
# }
# │ Error: Backend configuration changed
# │
# │ A change in the backend configuration has been detected, which may require migrating existing state.
# │
# │ If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
# │ If you wish to store the current configuration with no changes to the state, use "terraform init -reconfigure".
