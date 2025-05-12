### About
- A VPC containing reasonable subnets for deploying AWS EC2's.
- An EC2 within the VPC that has reasonable IAM permissions and associated
resources.

### AWS Resources
- 1 VPC
- 2 Public Subnet in 2 different Availability Zone
- 2 Private Subnet in 2 different Availability Zone
- 1 Internet Gateway for public access routing for the public subnet
- 4 Network Access Control List (NACL) for each subnets
- 2 Route Table for Private and Public access routing
- 1 Public EC2 instance in the Public Subnet for nginx server installation
- 1 IAM role for the Public EC2 instance profile
- 1 Security group for the Public EC2 instance

### Additionals
- A user data script is added to install Python 3.12 in the Public EC2 instance for compatibility with Ansible's python interpreter

### Commands
- aws sts get-caller-identity
- export AWS_PROFILE=playground
- terraform init -backend-config="bucket=hncpracticals-terraform-state"
- terraform apply -auto-approve
- terraform apply -var-file=env/uat.tfvars -var="stage=uat" -auto-approve

### Security Best Practice
- For SSH access, security groups and NACL have been modified to allow only from a specific source IP. A variable for the source IP address has been added to ensure consistent updates across all related AWS components
- Removed HTTP access in the EC2 instance security group and public NACL

###  Other Security considerations:
- EBS root volume encryption. Unable to apply due to Sandbox limitation in which a policy is preventing the cloud user from performing the ec2:RunInstances on the defined EBS encrypted volume. The EBS block is commented out
- Added public load balancer to serve traffic to the EC2 instance. With load balancer, WAF can be natively attached to add another layer of security. The load balancer will only serve HTTPS traffic (secured in-transit communications) to the nginx server. However, since there is no trusted certificate, the load balancer and WAF are commented out. The EC2 instance can be made private once a load balancer can redirect HTTPS traffic to it. However, a public EC2 bastion host needs to be created as a proxy to the web server for SSH access. Ansible scripts need to be configured accordingly.

