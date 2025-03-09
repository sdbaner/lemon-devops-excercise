# Agenda
Here, in this devops excercise, I have
- Deployed a fastAPI python app with three endpoints `/hello` , `/ready` and `/alive` in kubernetes.
- Configured AWS ALB (Apllicaton Load Balancer) for external access.
- Packaged application using helm-charts.
- Github action to deploy application on desired environment
- Automated provisioning of infrastructure (vpc,subnet,eks with managed nodes) in aws using terraform.



# Kubernetes manifests

## Assumptions/Considerations 
- This is a simple and small application deployed on kubernetes without secrets/database/pvc etc.
- Considering VPC with two subnets i.e. public and private. The private subnet hosts the eks cluster with no direct inbound access from internet. The public subnet consists of the Internet Gateway to allow internet access, Application Load Balancer to host external facing services and NAT gateway to enable outbound traffic from private subnet.
- Selecting the Application Load Balancer (ALB) as the workload is HTTP/HTTPS.The ALB is deployed in the public subnets and is accessible from the internet. By default the AWS Load Balancer controller will register targets using "Instance" type and this target will be the Worker Node’s IP and NodePort, implying traffic from the Load Balancer will be forwarded to the Worker Node on the NodePort.
- High available , high reliable and highly scalable application.
- Considering there are three different eks clusters for production grade application.



### Ensuring High Availabilty
- Define Pod disruption budgets to meet SLA.
- Define Priority classes to ensure pods get priority during scheduling.


### Ensuring Scalabilty
- Define Horizontal pod autoscaler.
- Combine HPA with Cluster Autoscaler to scale nodes dynamically to handle situations when HPA scales but nodes are full. 


### Ensuring Reliabilty
- health checks
- liveliness probe
- readiness probe
- monitoring/alerting

### Cost optimization
- Use serverless fargate for eks deployment

## Best practices for designing application
- Use Ingress to expose services. This is safe, provides host/path based routing, load balancing and cost effective.
- Use service mesh like Istio to handle circuit breaking, retries and security.
- Apply resource requests and limits to avoid OOMkills and CPU throttling.
- Apply readiness probe to check if container is ready to accept traffic.
- Apply liveliness probe to check if the container is responsive.
- Deploying application in proper namespace to provide isolation.
- Use RBAC to grant the minimum permissions needed to users, pods, and services.
- Define network policies to restrict pod to pod communication.
- Always use multi-stage builds in docker, shrink container sizes by removing unnecessary files before deploying to production.
- Setup proper observabilty to check cluster health using prometheus metrics and collect logs using fluentbit to troubleshoot errors.


### Security consideration -
- Scan containers for vulnerabilities
- Enforce security contexts to prevent privilege escalation by setting:
     runAsNonRoot: true
    allowPrivilegeEscalation: false
- Use secrets properly using kubernetes secrets.



## Folder structure
main-api/  
|-- lemon-api-charts/  
| |-- Chart.yaml  
| |-- values-dev.yaml
| |-- values-qa.yaml
| |-- values-prod.yaml  
| |-- templates/  
| | |-- deployment.yaml  
│ │ |-- service.yaml
| | |-- ingress.yaml
| | |-- pda.yaml
| | |-- hpa.yaml
| | |-- network-policy.yaml
| | |-- _helpers.tpl  
|-- main-api    
| |-- Dockerfile  
| |-- requirements.txt
| |-- api
| | |-- main.py
| |-- tests
| | |-- test_main.http 



Build docker image and push to docker hub
```
 docker build -t lemon-api .
 docker run -p 80:80 lemon-api:latest
 docker push sdbaner/lemon-api:latest 
```

Create helm charts and validate
```
 helm create lemon-api-charts
 Validate helm charts
 helm lint lemon-api-charts
```


# Terraform
- Terraform folder creates EKS on AWS using Terraform.
- The setup uses terraform modules for AWS VPC , EKS and ALB (to be defined)
- Github action for manually deploying the infrastructure


## Best practices
- Use modules, wherever possible, to avoid repeatations and maintain upgrades/versions.
- Use remote backend to store state file to enable collaboration and state locking.
- Maintain versioning of state file to prevent accidental loss.
- Leverage IAM roles and policies with least privilege access for Terraform execution and EKS access.
- Implement tagging across all AWS resources to improve management and cost tracking.
- Define security groups properly to restrict access to EKS nodes and application workloads.
- Use Terraform workspaces or directory-based separation for different environments (dev, qa, prod).

### ToDo 
- Use aws role `terraform-provisioner` to deploy terraform resources to ensure reliabilty and security. This aws role should have programmatic access to all create/access/delete the required resources only. Due to time constraints , I have used the root account to provision the infrastructure which is not a good practice.
- Use separate variable files for different environments.
- Install ALB Controller. This requires creating IAM Role for ALB Controller.
- Deploy ALB Controller Using Helm.
- Grant access to additional users for the EKS cluster.
