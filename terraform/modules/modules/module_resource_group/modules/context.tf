#
# ONLY EDIT THIS FILE IN https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label
# All other instances of this file should be a copy of that one
#
#
# Copy this file from https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label
# and then place it in your Terraform module to automatically get
# the standard configuration inputs suitable for passing
# to other modules.
#
# curl -sL https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label?path=/exports/context.tf -o context.tf
#
# Modules should access the whole context as `module.this.context`
# to get the input variables with nulls for defaults,
# for example `context = module.this.context`,
# and access individual variables as `module.this.<var>`,
# with final values filled in.
#
# For example, when using defaults, `module.this.context.delimiter`
# will be null, and `module.this.delimiter` will be `-` (hyphen).
#

module "this" {
  # source  = "git::https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label//modules"
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0" # requires Terraform >= 1.0.6
  # source = "../modules"

  enabled             = var.enabled
  namespace           = var.namespace
  project             = var.project
  name                = var.name
  region              = var.region
  environment         = var.environment
  delimiter           = var.delimiter
  attributes          = var.attributes
  tags                = var.tags
  additional_tag_map  = var.additional_tag_map
  label_order         = var.label_order
  regex_replace_chars = var.regex_replace_chars
  replacement         = var.replacement
  id_hash_length      = var.id_hash_length
  id_length_limit     = var.id_length_limit
  label_key_case      = var.label_key_case
  label_value_case    = var.label_value_case
  labels_as_tags      = var.labels_as_tags

  context = var.context
}

# Copy contents of https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label?path=/modules/variables.tf here



variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    project             = null
    name                = null
    region              = null
    environment         = null
    delimiter           = null
    attributes          = null
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = null
    replacement         = null
    id_hash_length      = null
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
    labels_as_tags      = null
  }
  description = <<-EOT
    Single object for setting entire context at once.
    See description of individual variables for details.
    Leave string and numeric variables as `null` to use default value.
    Individual variable settings (non-null) override settings in context object,
    except for attributes, tags, and additional_tag_map, which are merged.
  EOT

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually an abbreviation of your the resource type, e.g. 'rg' or 'kv', to help ensure generated IDs are globally unique"
}
variable "project" {
  type        = string
  default     = null
  description = "ID element. The project that the resource belongs to."
}

variable "name" {
  type        = string
  default     = null
  description = <<-EOT
    ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.
    This is the only ID element not also included as a `tag`.
    The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input.
    EOT
}

variable "region" {
  type        = string
  default     = null
  description = "ID element. Used for region e.g. 'centralus', 'Central US', OR role 'East US 1', 'eastus1'"
}
variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "delimiter" {
  type        = string
  default     = null
  description = <<-EOT
    Delimiter to be used between ID elements.
    Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
  EOT
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = <<-EOT
    ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,
    in the order they appear in the list. New attributes are appended to the
    end of the list. The elements of the list are joined by the `delimiter`
    and treated as a single ID element.
    EOT
}

variable "labels_as_tags" {
  type        = set(string)
  default     = null
  description = <<-EOT
    Set of labels (ID elements) to include as tags in the `tags` output.
    Default is to include all labels.
    Tags with empty values will not be included in the `tags` output.
    Set to `[]` to suppress all generated tags.
    **Notes:**
      The value of the `name` tag, if included, will be the `id`, not the `name`.
      Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be
      changed in later chained modules. Attempts to change it will be silently ignored.
    EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.
    This is for some rare cases where resources want additional configuration of tags
    and therefore take a list of maps with tag key, value, and additional configuration.
    EOT
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = <<-EOT
    The order in which the labels (ID elements) appear in the `id`.
    Defaults to ["namespace", "environment", "stage", "name", "attributes"].
    You can omit any of the 5 labels, but at least one must be present.
    EOT
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = <<-EOT
    Terraform regular expression (regex) string.
    Characters matching the regex will be removed from the ID elements.
    If not set, `"/[^-a-zA-Z0-9_]/"` is used to remove all characters other than hyphens, underscores, letters and digits.
  EOT
}

variable "replacement" {
  type        = string
  default     = null
  description = <<-EOT
    Terraform regular expression (regex) string.
    Characters matching the regex will be used to replace the characters in regex_replace_chars from the ID elements.
  EOT
}

variable "id_hash_length" {
  type        = number
  default     = null
  description = <<-EOT
    Limit `id` hash to this many characters (minimum 5).
    Set to `null` for keep the existing setting, which defaults to `5`.
    Does not affect `id_full`.
  EOT
  validation {
    condition     = var.id_hash_length == null ? true : var.id_hash_length >= 5
    error_message = "The id_hash_length must be >= 5 if supplied (not null)."
  }
}

variable "id_length_limit" {
  type        = number
  default     = null
  description = <<-EOT
    Limit `id` to this many characters (minimum 6).
    Set to `0` for unlimited length.
    Set to `null` for keep the existing setting, which defaults to `0`.
    Does not affect `id_full`.
  EOT
  validation {
    condition     = var.id_length_limit == null ? true : var.id_length_limit >= 6 || var.id_length_limit == 0
    error_message = "The id_length_limit must be >= 6 if supplied (not null), or 0 for unlimited length."
  }
}

variable "label_key_case" {
  type        = string
  default     = null
  description = <<-EOT
    Controls the letter case of the `tags` keys (label names) for tags generated by this module.
    Does not affect keys of tags passed in via the `tags` input.
    Possible values: `lower`, `title`, `upper`.
    Default value: `title`.
  EOT

  validation {
    condition     = var.label_key_case == null ? true : contains(["lower", "title", "upper"], var.label_key_case)
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }
}

variable "label_value_case" {
  type        = string
  default     = null
  description = <<-EOT
    Controls the letter case of ID elements (labels) as included in `id`,
    set as tag values, and output by this module individually.
    Does not affect values of tags passed in via the `tags` input.
    Possible values: `lower`, `title`, `upper` and `none` (no transformation).
    Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.
    Default value: `lower`.
  EOT

  validation {
    condition     = var.label_value_case == null ? true : contains(["lower", "title", "upper", "none"], var.label_value_case)
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

#### End of copy of https://dev.azure.com/fg-sparq/IaC-Modules/_git/terraform-facilisgroup-module_label?path=/modules/variables.tf
