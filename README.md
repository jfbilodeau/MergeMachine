# MergeMachine — GitHub DevOps Demo

This repository is a small ASP.NET application used as a GitHub DevOps demo. It includes:

- An ASP.NET web app targeting .NET 9
- A GitHub Actions workflow that builds, tests, deploys infrastructure (Bicep), and publishes the app to Azure App Service
- A Bicep template in `infra/MergeMachine.bicep` that creates an App Service Plan and Web App in `canadaeast`

## Run locally

Prerequisites:

- .NET SDK 9 installed (see https://dotnet.microsoft.com)
- (Optional) Azure CLI if you want to deploy locally

To run locally during development:

```bash
dotnet restore
dotnet build
dotnet run --project .
```

By default the app will run on `https://localhost:5001` (or as printed in the console).

## Test

Run unit tests (if any) with:

```bash
dotnet test
```

## CI/CD

The GitHub Actions workflow is at `.github/workflows/MergeMachine-cicd.yml`. It:

- Restores, builds, and tests the app
- Logs in to Azure using the `AZURE_CREDENTIALS` secret (service principal JSON)
- Deploys the Bicep template `infra/MergeMachine.bicep` to the `MergeMachine` resource group
- Publishes the application and zip-deploys it to the created Web App

To configure GitHub Actions for deployment:

1. Create a service principal scoped to the `MergeMachine` resource group and copy the JSON output:

```bash
az ad sp create-for-rbac --name "github-actions-merge-machine" --role contributor --scopes /subscriptions/<SUB_ID>/resourceGroups/MergeMachine
```

2. Add a repository secret named `AZURE_CREDENTIALS` with the JSON from step 1.

3. Push to `main` or open a pull request — the workflow will run and deploy.

## Infrastructure

The Bicep template is `infra/MergeMachine.bicep`. It creates:

- An App Service Plan (Standard S1 by default)
- An App Service (Linux) configured for `DOTNET|9.0`

You can deploy it locally with the Azure CLI:

```bash
az deployment group create \
  --resource-group MergeMachine \
  --template-file infra/MergeMachine.bicep \
  --parameters webAppName=<unique-webapp-name> appServicePlanName=<asp-name>
```

Notes:
- `webAppName` must be globally unique. The workflow creates a unique name per run by prefixing it with the GitHub run id.
- If you prefer a stable name, update the Bicep parameter or the workflow parameter.

## Next steps / Improvements

- Add Application Insights and diagnostic settings in the Bicep file
- Add slot support or staging deployments
- Secure configuration through Key Vault and managed identity

If you want me to make any of these improvements, tell me which one and I will implement it.
