Here, in this devops excercise, I have
- Deployed a fastAPI python app with three endpoints /hello , /ready and /alive in kubernetes.
- Configured AWS ALB (Apllicaton Load Balancer) for external access.
- Used Fargate for serverless worker nodes to simplifying scaling.
- Automated provisioning of infrastructure (vpc,subnet,eks with fargate) in aws using terraform.

## ToDo
- Reuse manifest file for different environments

### Assumptions 
- This is a simple and small application
- High available , high reliable and highly scalable application
- Single cluster with each environment running on a different namespace.


## Ensuring High Availabilty
- Define Pod disruption budgets to ensure minimum availabilty
- Define Priority classes to ensure pod scheduling gets priority


## Ensuring Scalabilty
- Define Horizontal pod autoscaler


## Ensuring Reliabilty
- health checks
- liveliness probe
- readiness probe
- monitoring/alerting

## Best practices for designing application
- setting resources requests/limits
- 

Security consideration -
- secrets
- configmaps
- network policies


main-api/  
|-- chart/  
| |-- Chart.yaml  
| |-- values.yaml  
| |-- templates/  
| | |-- deployment.yaml  
│ │ |-- service.yaml
| | |-- ingress.yaml
| | |-- pda.yaml
| | |-- hpa.yaml
| | |-- _helpers.tpl  
|-- NOTES.txt 
|-- main-api    
| |-- Dockerfile  
| |-- requirements.txt
| |-- src
| | |-- main.py
| | |-- test_main.http 



Build docker image and push to docker hub
```
 docker build -t lemon-api .
 docker run -p 80:80 lemon-api:latest
 docker push sdbaner/lemon-api:latest 
```

Create helm charts
```
 helm create lemon-api-charts
```

Validate helm charts
```
helm lint lemon-api-charts
```


