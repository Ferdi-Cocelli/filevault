output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.filevault.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.filevault.name
}

output "storage_account_primary_key" {
  description = "Primary access key for storage account"
  value       = azurerm_storage_account.filevault.primary_access_key
  sensitive   = true
}

output "storage_container_name" {
  description = "Name of the blob storage container"
  value       = azurerm_storage_container.filevault.name
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.filevault.instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.filevault.connection_string
  sensitive   = true
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.filevault.name
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.filevault.default_hostname
}

output "app_service_url" {
  description = "Full URL of the App Service"
  value       = "https://${azurerm_linux_web_app.filevault.default_hostname}"
}
