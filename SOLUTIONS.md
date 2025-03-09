# Agenda
Here, in this devops excercise, I have
- Deployed a fastAPI python app with three endpoints `/hello` , `/ready` and `/alive` in kubernetes.
- Configured AWS ALB (Apllicaton Load Balancer) for external access.
- Packaged application using helm-charts.
- Github action to deploy application on desired environment
- Automated provisioning of infrastructure (vpc,subnet,eks with managed nodes) in aws using terraform.
- There are two parts of the solution 1) kubernetes and 2) Terraform


# Problem statement 1 
Develop high available and scalable API with kubernetes manifests file

## Assumptions/Considerations 
- This is a simple and small application deployed on kubernetes without secrets/database/pvc etc handling.
- Considering VPC with two subnets i.e. public and private. The private subnet hosts the eks cluster with no direct inbound access from internet. The public subnet consists of the Internet Gateway to allow internet access, Application Load Balancer to host external facing services and NAT gateway to enable outbound traffic from private subnet.
- Selecting the Application Load Balancer (ALB) as the workload is HTTP/HTTPS. The ALB is deployed in the public subnets and is accessible from the internet. By default the AWS Load Balancer controller will register targets using "Instance" type and this target will be the Worker Node’s IP and NodePort, implying traffic from the Load Balancer will be forwarded to the Worker Node on the NodePort.
- Objective is to make the application high available and highly scalable. Such situtations can arise in below cases:
  * rise in user base
  * new features/complexities
  * Increase in content/data volume
  * expand application in geo locations
- Considering there are three different eks clusters (dev, staging and live) for production grade application.



### How do I ensure High Availabilty ( which has been implemented)
- Define Pod disruption budgets to meet SLA.
- Define Priority classes to ensure pods get priority during scheduling.
- Deploy the eks/vpc with multiple availabilty zones.

#### Further enhancements that can be made (not yet implemented)
- Deploy the application in multiple cloud regions to reduce latency and improve redundancy.(have not implemented but good to have)


### How do I ensure Scalabilty ( which has been implemented)
- Define Horizontal pod autoscaler to add replicas when it reaches a certain cpu/memory threshold
- Implement Load balancing to distribute traffic across multiple servers to ensure no single server becomes bottleneck.

#### Further enhancements that can be made (not yet implemented)
- Combine HPA with Cluster Autoscaler to scale nodes dynamically. This is useful in situations when HPA scales but nodes are full.
- Caching is a technique to store frequently accessed data in-memory (like redis) to reduce the load on the server or database.
- CDN distributes static assets (images, videos, etc.) closer to users. This can reduce latency and result in faster load times.


### How do I ensure Reliabilty
- health checks
- liveliness probe
- readiness probe
- monitoring/alerting (yet to be implemented)

### Cost optimization (further enhancements)
- Use serverless fargate for eks deployment

## Best practices for designing application (which has been implemented)
- Use Ingress to expose services. This is safe, provides host/path based routing, load balancing and cost effective.
- Apply resource requests and limits to avoid OOMkills and CPU throttling.
- Apply readiness probe to check if container is ready to accept traffic.
- Apply liveliness probe to check if the container is responsive.
- Define network policies to restrict pod to pod communication.
- Deploying application in proper namespace to provide isolation.
- Always use multi-stage builds in docker, shrink container sizes by removing unnecessary files before deploying to production.

### Best practices for designing application (yet to be implemented) 
- Use service mesh like Istio to handle circuit breaking, retries and security.
- Use RBAC to grant the minimum permissions needed to users, pods, and services.
- Setup proper observabilty to check cluster health using prometheus metrics and collect logs using fluentbit to troubleshoot errors.


### Security consideration (yet to be implemented) 
- Scan containers for vulnerabilities
- Enforce security contexts to prevent privilege escalation by setting:
     runAsNonRoot: true
    allowPrivilegeEscalation: false
- Use secrets properly using kubernetes secrets.
  


### Steps to setup

1. Install AWS CLI and terraform to 

2. Build docker image and push to docker hub
```
 docker build -t lemon-api .
 docker run -p 80:80 lemon-api:latest
 docker push sdbaner/lemon-api:latest 
```

3. Create helm charts and modify the manifests file accordingly. Validate the files.
```
 helm create lemon-api-charts
 Validate helm charts
 helm lint lemon-api-charts
```


# Problem statement 2
Create infrastructure with Terraform

- Terraform folder creates EKS on AWS using Terraform.
- The setup uses terraform modules for AWS VPC , EKS and ALB (to be defined)
- Github action for manually(for now) deploying the infrastructure


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
