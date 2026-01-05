terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "filevault" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account
resource "azurerm_storage_account" "filevault" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.filevault.name
  location                 = azurerm_resource_group.filevault.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version          = "TLS1_2"
  enable_https_traffic_only = true

  tags = var.tags
}

# Blob Container
resource "azurerm_storage_container" "filevault" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.filevault.name
  container_access_type = "private"
}

# Application Insights
resource "azurerm_application_insights" "filevault" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.filevault.location
  resource_group_name = azurerm_resource_group.filevault.name
  application_type    = "Node.JS"

  tags = var.tags
}

# App Service Plan
resource "azurerm_service_plan" "filevault" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.filevault.location
  resource_group_name = azurerm_resource_group.filevault.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku

  tags = var.tags
}

# App Service (Web App)
resource "azurerm_linux_web_app" "filevault" {
  name                = var.app_service_name
  location            = azurerm_resource_group.filevault.location
  resource_group_name = azurerm_resource_group.filevault.name
  service_plan_id     = azurerm_service_plan.filevault.id

  site_config {
    always_on = true

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.filevault.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "AZURE_STORAGE_ACCOUNT_NAME" = azurerm_storage_account.filevault.name
    "AZURE_STORAGE_ACCOUNT_KEY" = azurerm_storage_account.filevault.primary_access_key
    "AZURE_CONTAINER_NAME" = azurerm_storage_container.filevault.name
    "PORT" = "3000"
  }

  tags = var.tags
}
