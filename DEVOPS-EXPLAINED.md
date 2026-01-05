# DevOps Tools Explained

Quick reference for what each tool does and why you'd use it.

## Overview

The goal is automating everything from code to production:

```
Code → Test → Build → Deploy → Monitor
```

## What Each Tool Does

### Terraform

Creates Azure resources automatically. Instead of clicking around Azure Portal for 30 minutes, you run `terraform apply` and it creates everything.

Key files:
- `terraform/main.tf` - defines what to create
- `terraform/variables.tf` - customizable settings
- `terraform/outputs.tf` - values you get back

Why use it:
- Version control your infrastructure
- Recreate entire environment in seconds
- Same setup every time, no human error
- Industry standard for Infrastructure as Code

---

### SonarQube

Scans your code for bugs, security issues, and bad practices. Run `npm run sonar` and it'll show you what needs fixing.

Files:
- `sonar-project.properties` - configuration
- `.eslintrc.json` - code style rules

Note: I set the threshold to 10% coverage, so it won't fail your builds while you're learning.

---

### Jest

Runs your unit tests. Run `npm test` and it shows which tests passed/failed plus coverage reports.

Files:
- `jest.config.js` - test configuration
- `__tests__/app.test.js` - your tests

Right now there's just a sample test, which is fine for learning.

---

### ESLint

Checks code style - quotes, semicolons, variable naming, etc. Run `npm run lint` to check, `npm run lint:fix` to auto-fix simple issues.

Files:
- `.eslintrc.json` - the style rules

---

### GitHub Actions

Automatically runs tasks when you push code. The workflow in `.github/workflows/ci-cd.yml` does:
1. Install dependencies
2. Run linter
3. Run tests
4. Send to SonarQube
5. Validate Terraform
6. Deploy to Azure (on main branch only)

---

### Application Insights

Monitors your app in production. Shows requests per second, response times, failures, errors, and dependency calls. You already used this to find the storage account issue.

---

## How They Work Together

When you make a code change:
1. Write code, commit, push
2. GitHub Actions triggers
3. Runs linter and tests
4. Sends to SonarQube for analysis
5. Validates Terraform config
6. Deploys to Azure (if on main branch)
7. Application Insights monitors the live app

When you need new infrastructure:
1. Edit `terraform/main.tf`
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to create resources
4. Use `terraform output` to get connection strings
5. Update app code to use new resources
6. Push to GitHub and CI/CD handles deployment

## Quick Commands

```bash
# Terraform
cd terraform
terraform init       # setup
terraform plan       # preview changes
terraform apply      # create/update resources
terraform destroy    # delete everything

# Code Quality
cd src/azure-sa
npm run lint         # check code style
npm run lint:fix     # auto-fix simple issues
npm test             # run tests
npm run sonar        # send to SonarQube

# Deployment
git add .
git commit -m "message"
git push             # triggers CI/CD

# Monitoring
# Azure Portal → Application Insights → Live Metrics
```

## What You're Learning

Using these tools covers the main DevOps areas:
- Infrastructure as Code (Terraform)
- Continuous Integration (GitHub Actions + Testing)
- Continuous Deployment (GitHub Actions + Azure)
- Code Quality (SonarQube + ESLint)
- Testing (Jest)
- Monitoring (Application Insights)
- Version Control (Git/GitHub)
- Cloud Platforms (Azure)
