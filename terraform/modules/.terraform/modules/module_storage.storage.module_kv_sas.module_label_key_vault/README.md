# iac-stg-module-terraform-tags

- This is a module to enforce consistent naming and tagging of resources.

## TODO

- use billing group tag in label
- add sparq to environment or disambiguate
- changelog for versioning
- add default tags to module
- add casing to default tags with option to override? or separate override casing list?
- [use git commands to get url](https://github.com/fivexl/terraform-aws-tag-generator/blob/master/main.tf)
- [tag based on filepath](https://github.com/aztfmod/terraform-azurerm-caf-keyvault/blob/master/main.tf)
- enforce underscore for name
- use allowed values for application and map to application id
- use allowed values for deployment and sub types
- enforce naming for contact
- tie version to repo tag & changelog
- tie stgApp tag to environment with option to override/add to other envs
- add unit tests
- make sure repo name doesn't contain environment - and also appRepository and iacRepository tags
- make 'slug' available for workspace prefix
- add example
- add usage
- add context, variables to readme (maybe if not too much of a duplicate of autogen from variables/outputs)
- add environment to end of truncated/hashed id

## terraform

- progress
  - v0.1.0
    - update name to use underscores for linting
    - add id_hash_length to vars
    - add replacement to vars
    - move environment to end of order to match workspace prefix logic
    - add project as separate default entry (not environment)
    - add underscore to allowed chars in regex replace
    - remove backend see comment in file
