variable "project_id" {
  description = "Existing Google Cloud project in which to build the project-level foundation."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Region for both subnets."
  type        = string
  default     = "europe-west1"
}

variable "name_prefix" {
  description = "Short prefix for resources; use lowercase letters, numbers, and hyphens."
  type        = string
  default     = "fabric-demo"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,20}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-22 characters and start/end with a letter or number."
  }
}

variable "environments" {
  description = "Separated development and production address spaces."
  type = map(object({
    subnet_cidr   = string
    pods_cidr     = string
    services_cidr = string
  }))

  default = {
    dev = {
      subnet_cidr   = "10.20.0.0/24"
      pods_cidr     = "10.21.0.0/20"
      services_cidr = "10.22.0.0/24"
    }
    prod = {
      subnet_cidr   = "10.30.0.0/24"
      pods_cidr     = "10.31.0.0/20"
      services_cidr = "10.32.0.0/24"
    }
  }

  validation {
    condition     = length(var.environments) == 2 && contains(keys(var.environments), "dev") && contains(keys(var.environments), "prod")
    error_message = "This demo expects exactly dev and prod environments."
  }
}

