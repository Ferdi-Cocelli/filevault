# FileVault Infrastructure - Terraform

This directory contains Terraform configuration to provision and manage the FileVault application infrastructure on Azure.

## Resources Managed

- **Resource Group**: Container for all Azure resources
- **Storage Account**: Azure Blob Storage for file uploads
- **Storage Container**: Blob container for storing files
- **Application Insights**: Monitoring and telemetry
- **App Service Plan**: Hosting plan for the web application
- **Linux Web App**: The FileVault application

## Prerequisites

1. **Azure CLI** installed and authenticated:
   ```bash
   az login
   ```

2. **Terraform** installed (v1.0+):
   ```bash
   # macOS
   brew install terraform

   # Verify
   terraform version
   ```

## Quick Start

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

### 2. Review the Plan

```bash
terraform plan
```

### 3. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to create the resources.

### 4. View Outputs

```bash
terraform output
terraform output -json
terraform output app_service_url
```

## Configuration

### Variables

Customize variables in `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

Key variables:
- `resource_group_name` - Name of the resource group
- `location` - Azure region (uksouth, westeurope, etc.)
- `storage_account_name` - Globally unique storage account name
- `app_service_name` - Globally unique app service name
- `app_service_sku` - App Service tier (B1, S1, P1v2, etc.)

### Remote State (Optional but Recommended)

To store Terraform state remotely in Azure Storage:

1. Create state storage:
   ```bash
   az group create --name terraform-state-rg --location uksouth
   az storage account create --name tfstatefilevault \
     --resource-group terraform-state-rg \
     --location uksouth \
     --sku Standard_LRS
   az storage container create --name tfstate \
     --account-name tfstatefilevault
   ```

2. Uncomment the backend configuration in `backend.tf`

3. Re-initialize Terraform:
   ```bash
   terraform init -migrate-state
   ```

## Common Commands

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# Show current state
terraform show

# List resources
terraform state list

# Get specific output
terraform output app_service_url
```

## Environment-Specific Deployments

### Development
```bash
terraform apply -var="environment=dev"
```

### Production
```bash
terraform apply -var="environment=prod" -var="app_service_sku=P1v2"
```

## Import Existing Resources

If you already have resources created manually, you can import them:

```bash
# Import resource group
terraform import azurerm_resource_group.filevault /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg

# Import storage account
terraform import azurerm_storage_account.filevault /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg/providers/Microsoft.Storage/storageAccounts/wocfilevault
```

## Outputs

After applying, Terraform will output:
- `app_service_url` - URL to access your application
- `storage_account_name` - Name of the storage account
- `app_insights_connection_string` - For local development (sensitive)

## Security Notes

- Never commit `terraform.tfvars` to version control (it's in `.gitignore`)
- Sensitive outputs are marked and won't display in logs
- Storage account keys are managed by Terraform and auto-configured in App Service

## Troubleshooting

### Resource Already Exists
If resources already exist, either:
1. Import them using `terraform import`
2. Or destroy and recreate with `terraform apply`

### State Lock Issues
If using remote state and encountering locks:
```bash
terraform force-unlock <LOCK_ID>
```

### Name Conflicts
Storage account names must be globally unique. If you get a naming conflict:
1. Change `storage_account_name` in `terraform.tfvars`
2. Ensure it's 3-24 lowercase alphanumeric characters

## Next Steps

After infrastructure is provisioned:
1. Deploy application code using Azure CLI or GitHub Actions
2. Configure custom domain and SSL certificate
3. Set up alerts and monitoring in Application Insights
4. Configure backup and disaster recovery
