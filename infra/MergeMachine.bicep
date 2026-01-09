@description('Name of the App Service Plan to create')
param appServicePlanName string = 'mergeMachine-asp'

@description('Name of the Web App to create')
param webAppName string = 'mergemachinep'

@description('Location for all resources')
param location string = 'canadaeast'

@description('SKU for the App Service Plan. Format: {name, tier, size, capacity}')
param sku object = {
  name: 'S1'
  tier: 'Standard'
  size: 'S1'
  capacity: 1
}

@description('Linux runtime stack for the Web App')
param linuxFxVersion string = 'DOTNET|9.0'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku.name
    tier: sku.tier
    size: sku.size
    capacity: sku.capacity
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      alwaysOn: true
      http20Enabled: true
    }
  }
}

output appServicePlanId string = appServicePlan.id
output webAppDefaultHostName string = webApp.properties.defaultHostName
