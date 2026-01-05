variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "woc-deployment-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "uksouth"
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account (must be globally unique, 3-24 lowercase alphanumeric characters)"
  type        = string
  default     = "wocfilevault"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be 3-24 lowercase alphanumeric characters."
  }
}

variable "container_name" {
  description = "Name of the blob storage container"
  type        = string
  default     = "firevault-files"
}

variable "app_insights_name" {
  description = "Name of Application Insights instance"
  type        = string
  default     = "woc-filevault-app-insights"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "woc-filevault-plan"
}

variable "app_service_name" {
  description = "Name of the App Service (must be globally unique)"
  type        = string
  default     = "woc-filevault-app"
}

variable "app_service_sku" {
  description = "SKU for App Service Plan (e.g., B1, S1, P1v2)"
  type        = string
  default     = "B1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "FileVault"
    ManagedBy   = "Terraform"
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}
