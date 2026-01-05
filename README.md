# FileVault

FileVault is a modern file uploading application with versions for both AWS S3 and Azure Blob Storage. It features a clean interface with light/dark mode toggle and file management capabilities.

## Application Screenshots

### FileVault Interface

![FileVault](images/filevault.png)

### Upload File to Azure Storage Account

![Upload File to Azure Storage Account](images/upload-file-to-azure-storage-account.png)

The upload screen allows you to select a file and enter a name for the file. Upon clicking the submit button, the file is uploaded to the Azure Blob Storage.

### File Appears in Azure Storage Account

![File Appears in Azure SA](images/file-appears-in-azure-sa.png)

This screen shows the file successfully uploaded to the Azure Blob Storage container. The table displays the file name and its corresponding key.

### Delete File

![Delete File](images/delete-file.png)

This screen demonstrates the delete functionality. Clicking the delete button removes the file from the cloud storage and updates the table accordingly.

### File Removed from Azure Storage Account

![File Removed from Azure SA](images/file-removed-from-azure-sa.png)

This screen shows that the file has been successfully deleted from the Azure Blob Storage container, and the table has been updated to reflect this.

### Toggle Light/Dark Mode

![Toggle Light/Dark Mode](images/toggle.png)

This screen shows the light mode when you slide the toggle switch.

## Features

- Upload files to cloud storage (AWS S3 or Azure Blob Storage).
- Save and retrieve file metadata.
- Delete files directly from the table.
- Light/Dark mode toggle.

## Prerequisites

- Node.js
- AWS or Azure account with appropriate storage setup
- AWS S3 bucket or Azure Storage Account and Container
- Appropriate credentials for AWS or Azure

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/yourusername/filevault.git
cd filevault
```

## Project Structure

```
filevault/
├── src/
│   ├── aws-s3/
│   │   ├── public/
│   │   │   ├── app.js
│   │   │   ├── index.html
│   │   │   └── styles.css
│   │   ├── uploads/
│   │   ├── filesData.json
│   │   ├── .env.example
│   │   ├── index.js
│   │   ├── package.json
│   │   └── package-lock.json
│   ├── azure-blob/
│   │   ├── public/
│   │   │   ├── app.js
│   │   │   ├── index.html
│   │   │   └── styles.css
│   │   ├── uploads/
│   │   ├── filesData.json
│   │   ├── .env.example
│   │   ├── index.js
│   │   ├── package.json
│   │   └── package-lock.json
├── images/
│   ├── filevault.png
│   ├── upload-file-to-azure-storage-account.png
│   ├── file-appears-in-azure-sa.png
│   ├── delete-file.png
│   ├── file-removed-from-azure-sa.png
|   ├── toggle.png
├── .gitignore
└── README.md
```

## Setup for AWS S3

### Configuration

Navigate to the `src/aws-s3` directory and create a `.env` file based on the `.env.example`:

```
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key
AWS_REGION=your-region
S3_BUCKET_NAME=your-s3-bucket-name
PORT=3000
```

### Install Dependencies

```
cd src/aws-s3
npm install express multer dotenv @aws-sdk/client-s3 @aws-sdk/lib-storage
```

## Setup on Azure Storage Accounts

### Configuration

Navigate to the `src/azure-blob` directory and create a `.env` file based on the `.env.example`:

```
AZURE_STORAGE_ACCOUNT_NAME=your-storage-account-name
AZURE_STORAGE_ACCOUNT_KEY=your-storage-account-key
AZURE_CONTAINER_NAME=your-container-name
PORT=3000
```

### Install Dependencies

```
cd src/azure-blob
npm install express multer dotenv @azure/storage-blob
```

## Running and Accessing the Application

```
node index.js
```

Open your browser and navigate to `http://localhost:3000`.

## Technologies Used

- Node.js
- AWS S3 or Azure Storage Accounts
- HTML, CSS, JavaScript

## Infrastructure as Code (Terraform)

FileVault uses Terraform to provision and manage Azure infrastructure. All infrastructure configuration is located in the `terraform/` directory.

### Quick Start with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

See [terraform/README.md](terraform/README.md) for detailed documentation.

### Resources Managed

- Azure Resource Group
- Azure Storage Account & Container
- Azure App Service Plan & Web App
- Application Insights

## Code Quality & Security (SonarQube)

FileVault integrates with SonarQube/SonarCloud for continuous code quality and security analysis.

### Local SonarQube Analysis

1. Install SonarQube Scanner:
   ```bash
   npm install -g sonarqube-scanner
   ```

2. Run analysis:
   ```bash
   cd src/azure-sa
   npm run sonar
   ```

### SonarCloud Integration

Configure the following secrets in GitHub:
- `SONAR_TOKEN` - Your SonarCloud token
- `SONAR_PROJECT_KEY` - Your project key
- `SONAR_ORGANIZATION` - Your organization name

## CI/CD Pipeline

FileVault includes a comprehensive GitHub Actions workflow (`.github/workflows/ci-cd.yml`) that:

1. **Code Quality Checks**
   - Linting with ESLint
   - Unit tests with Jest
   - SonarCloud security & quality analysis

2. **Terraform Validation**
   - Format checking
   - Configuration validation
   - Plan generation for PRs

3. **Automated Deployment**
   - Build and package application
   - Deploy to Azure App Service
   - Automatic restart

### Required GitHub Secrets

- `AZURE_CREDENTIALS` - Azure service principal credentials
- `SONAR_TOKEN` - SonarCloud authentication token
- `SONAR_PROJECT_KEY` - SonarCloud project identifier
- `SONAR_ORGANIZATION` - SonarCloud organization name

### Setting up Azure Credentials

```bash
az ad sp create-for-rbac --name "filevault-github-actions" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/woc-deployment-rg \
  --sdk-auth
```

Copy the JSON output and add it as `AZURE_CREDENTIALS` secret in GitHub.

## Monitoring & Application Insights

FileVault includes Application Insights integration for:
- Real-time performance monitoring
- Request/dependency tracking
- Exception logging
- Custom telemetry

Access metrics at: [Azure Portal > Application Insights](https://portal.azure.com)

## To-Do

- [ ] **Use a Database for Persistent Data**: Replace the `filesData.json` with a database (e.g., MongoDB, PostgreSQL) to store file metadata persistently.

- [ ] **User Authentication**: Implement user authentication to manage user-specific files securely.

- [ ] **File Search and Filtering**: Add functionality to search and filter files in the table.

- [ ] **Drag and Drop Upload**: Enhance the upload feature with drag and drop functionality.

- [ ] **Enhanced Testing**: Add integration and E2E tests

- [ ] **Container Registry**: Use Azure Container Registry for Docker images

