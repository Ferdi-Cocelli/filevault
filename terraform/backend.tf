# Terraform Backend Configuration
# Uncomment and configure this to store state remotely in Azure Storage

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-state-rg"
#     storage_account_name = "tfstatefilevault"
#     container_name       = "tfstate"
#     key                  = "filevault.tfstate"
#   }
# }

# To set up remote state:
# 1. Create a storage account for Terraform state:
#    az group create --name terraform-state-rg --location uksouth
#    az storage account create --name tfstatefilevault --resource-group terraform-state-rg --location uksouth --sku Standard_LRS
#    az storage container create --name tfstate --account-name tfstatefilevault
#
# 2. Uncomment the backend block above
#
# 3. Run: terraform init -backend-config="access_key=<STORAGE_ACCOUNT_KEY>"
