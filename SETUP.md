# FileVault - Complete Setup Guide

This guide walks you through setting up FileVault with Terraform and SonarQube integration.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development-setup)
3. [Infrastructure Setup with Terraform](#infrastructure-setup-with-terraform)
4. [SonarQube Setup](#sonarqube-setup)
5. [CI/CD Setup](#cicd-setup)
6. [Monitoring Setup](#monitoring-setup)

## Prerequisites

Install the following tools:

```bash
# Node.js (v18+)
node --version

# Azure CLI
az --version
az login

# Terraform
terraform --version

# Git
git --version
```

## Local Development Setup

### 1. Clone and Install

```bash
git clone <your-repo-url>
cd filevault
cd src/azure-sa
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your Azure credentials
```

### 3. Run Locally

```bash
npm start
# Open http://localhost:3000
```

## Infrastructure Setup with Terraform

### Option 1: Use Existing Resources

If you already have Azure resources created:

```bash
cd terraform
terraform init

# Import existing resources
terraform import azurerm_resource_group.filevault /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg
terraform import azurerm_storage_account.filevault /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg/providers/Microsoft.Storage/storageAccounts/wocfilevault
# ... import other resources
```

### Option 2: Create New Resources

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Get Infrastructure Outputs

```bash
terraform output
terraform output -json > ../terraform-outputs.json
```

## SonarQube Setup

### SonarCloud (Recommended for GitHub)

1. **Create SonarCloud Account**
   - Go to https://sonarcloud.io
   - Sign in with GitHub
   - Create new organization

2. **Create Project**
   - Click "+" → "Analyze new project"
   - Select your repository
   - Get your project key and token

3. **Configure Project**
   - Update `sonar-project.properties`:
     ```properties
     sonar.organization=your-org
     sonar.projectKey=your-project-key
     ```

4. **Add GitHub Secrets**
   ```
   SONAR_TOKEN=<your-token>
   SONAR_PROJECT_KEY=filevault
   SONAR_ORGANIZATION=<your-org>
   ```

### Local SonarQube Server

1. **Run SonarQube with Docker**
   ```bash
   docker run -d --name sonarqube -p 9000:9000 sonarqube:lts
   ```

2. **Access SonarQube**
   - Open http://localhost:9000
   - Login: admin/admin
   - Create new project and get token

3. **Run Analysis**
   ```bash
   cd src/azure-sa
   npm run sonar -- \
     -Dsonar.host.url=http://localhost:9000 \
     -Dsonar.login=<your-token>
   ```

## CI/CD Setup

### 1. Create Azure Service Principal

```bash
az ad sp create-for-rbac \
  --name "filevault-github-actions" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg \
  --sdk-auth
```

Copy the entire JSON output.

### 2. Configure GitHub Secrets

Go to GitHub → Settings → Secrets and variables → Actions

Add these secrets:
- `AZURE_CREDENTIALS` - The JSON from step 1
- `SONAR_TOKEN` - Your SonarCloud token
- `SONAR_PROJECT_KEY` - Your project key
- `SONAR_ORGANIZATION` - Your organization

### 3. Enable GitHub Actions

Push to main branch to trigger the workflow:

```bash
git add .
git commit -m "Add Terraform and SonarQube configuration"
git push origin main
```

### 4. Monitor Workflow

- Go to GitHub → Actions
- Watch the pipeline execute
- Check for any failures

## Monitoring Setup

### Application Insights

Your app is already configured with Application Insights if you used Terraform.

1. **Access Application Insights**
   ```bash
   az portal open -r <APP_INSIGHTS_RESOURCE_ID>
   ```

2. **View Key Metrics**
   - Live Metrics Stream
   - Performance
   - Failures
   - Logs

### Set Up Alerts

```bash
# Create alert for high failure rate
az monitor metrics alert create \
  --name "High failure rate" \
  --resource-group woc-deployment-rg \
  --scopes <APP_INSIGHTS_RESOURCE_ID> \
  --condition "avg requests/failed > 5" \
  --description "Alert when failure rate is high"
```

## Testing the Complete Setup

### 1. Test Local Development

```bash
cd src/azure-sa
npm test
npm run lint
npm start
```

### 2. Test Terraform

```bash
cd terraform
terraform validate
terraform plan
```

### 3. Test SonarQube

```bash
cd src/azure-sa
npm run sonar
```

### 4. Test Deployment

```bash
# Trigger manual deployment
git push origin main

# Or use Azure CLI
az webapp deployment source config-zip \
  --resource-group woc-deployment-rg \
  --name woc-filevault-app \
  --src deploy.zip
```

## Troubleshooting

### Terraform Issues

**Problem**: Resource already exists
```bash
# Solution: Import existing resource
terraform import <resource_type>.<name> <azure_resource_id>
```

**Problem**: State locked
```bash
# Solution: Force unlock
terraform force-unlock <LOCK_ID>
```

### SonarQube Issues

**Problem**: Analysis fails
```bash
# Check sonar-project.properties
# Verify SONAR_TOKEN is valid
# Check coverage files exist
```

### Deployment Issues

**Problem**: App Service won't start
```bash
# Check logs
az webapp log tail --name woc-filevault-app --resource-group woc-deployment-rg

# Check environment variables
az webapp config appsettings list --name woc-filevault-app --resource-group woc-deployment-rg
```

## Best Practices

1. **Never commit secrets**
   - Use `.env` for local development
   - Use Azure Key Vault for production
   - Use GitHub Secrets for CI/CD

2. **Use Terraform workspaces** for multiple environments
   ```bash
   terraform workspace new dev
   terraform workspace new prod
   ```

3. **Enable Terraform remote state**
   - Uncomment backend.tf
   - Store state in Azure Storage

4. **Monitor code quality**
   - Review SonarQube reports regularly
   - Fix critical issues before merging
   - Set quality gates in SonarCloud

5. **Regular testing**
   - Write unit tests
   - Run tests before commits
   - Use pre-commit hooks

## Next Steps

- [ ] Add comprehensive tests
- [ ] Set up staging environment
- [ ] Configure custom domain
- [ ] Add SSL certificate
- [ ] Implement user authentication
- [ ] Add database for metadata
- [ ] Set up backup strategy
- [ ] Create disaster recovery plan

## Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [SonarCloud Documentation](https://docs.sonarcloud.io/)
- [Azure App Service Docs](https://docs.microsoft.com/en-us/azure/app-service/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Application Insights Docs](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
