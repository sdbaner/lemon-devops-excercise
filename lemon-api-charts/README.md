# Deploying the Lemon fastAPI Application Using Helm

## Validate helm chart
```
helm lint lemon-api-chart
```

## Install the Helm Chart
```
helm install lemon-api-chart ./chart
```

## Verify Deployment
```
kubectl get pods  
kubectl get service
```
