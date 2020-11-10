variable "name" {
  description = "Bucket Name"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "acl" {
  description = "Access level control"
  default     = "log-delivery-write"
}

variable "retention_days" {
  default     = 10
  description = "Log files retention days"
}

