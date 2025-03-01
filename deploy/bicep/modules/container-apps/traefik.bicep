param containerAppsEnvName string
param location string

resource cappsEnv 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: containerAppsEnvName
}

resource traefik 'Microsoft.Web/containerApps@2021-03-01' = {
  name: 'reddog'
  location: location
  properties: {
    kubeEnvironmentId: cappsEnv.id
    template: {
      containers: [
        {
          name: 'traefik'
          image: 'ghcr.io/azure/reddog-retail-demo/reddog-traefik:latest'
        }
      ]
      scale: {
        minReplicas: 0
      }
      dapr: {
        enabled: true
        appId: 'traefik'
      }
    }
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
  }
}

output subdomain string = traefik.name
