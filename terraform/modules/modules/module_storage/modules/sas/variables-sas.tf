variable "generate_sas_for_storage_account" {
  type        = bool
  default     = false
  description = "Whether a sas token will be generated for the storage account or container."
}

variable "generate_sas_for_storage_container" {
  type        = bool
  default     = false
  description = "Whether a sas token will be generated for the storage account or container."
}

variable "connection_string" {
  type        = string
  default     = null
  description = "This is the connection string for the storage account."
}

variable "start" {
  description = "Start of SAS token validity. Defaults to now."
  type        = string
  //  validation {
  //    condition     = can(formatdate("", coalesce(var.start, timestamp())))
  //    error_message = "The start argument requires a valid RFC 3339 timestamp."
  //  }
  default = null
}

variable "rotation_days" {
  description = "How many days until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_hours" {
  description = "How many hours until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_minutes" {
  description = "How many minutes until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_months" {
  description = "How many months until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_years" {
  description = "How many years until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_margin" {
  type    = string
  default = "24h"
  //  validation {
  //    condition     = can(timeadd(timestamp(), var.rotation_margin))
  //    error_message = "The rotation_margin argument requires a valid duration."
  //  }
  description = "Margin to set on the validity of the SAS token. The SAS token remains valid for this duration after the moment that the rotation should take place. Syntax is the same as the timeadd() function."
}

variable "write" {
  description = "Collection of all writing-related permissions (includes creation and deletion)."
  type        = bool
  default     = true
}

variable "storage_container_name" {
  description = "Name of the storage container. Leave this empty to create a SAS token for the complete storage account."
  type        = string
  default     = null
}
