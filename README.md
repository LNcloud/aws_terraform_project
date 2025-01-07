Project: AWS Infrastructure with Terraform
This Terraform project creates a  infrastructure on AWS with the following resources:

VPC (Virtual Private Cloud)
Public Subnets (2)
Internet Gateway (IGW)
Route Tables and Associations
Security Groups for EC2 Instances and Load Balancer
EC2 Instances (2)
Application Load Balancer (ALB)
Target Group for ALB
Listener for ALB

Prerequisites
Before running this Terraform code, you need to have the following:

AWS Account: An AWS account with the necessary permissions to create resources.
Terraform: Installed on your local machine. 
AWS CLI: Installed and configured with your AWS credentials.

Files in this Project

main.tf: Contains the Terraform resources to create the AWS infrastructure.
variables.tf: Contains variables used throughout the main.tf.
userdata1.sh & userdata2.sh: Scripts to initialize the web servers.

Resources Created
1. VPC (Virtual Private Cloud)
Creates a VPC with a CIDR block defined by var.vpc_cidr.
2. Public Subnets (2)
Two public subnets (subnet1 and subnet2) are created in different availability zones (subnet1_az and subnet2_az).
3. Internet Gateway (IGW)
An internet gateway is created and attached to the VPC to allow communication between the VPC and the internet.
4. Route Tables
A route table is created and associated with both public subnets. The route table allows outbound internet access (0.0.0.0/0) via the internet gateway.
5. Security Group
A security group project_sg is created for the EC2 instances and Load Balancer.
Inbound Rules: HTTP (port 80) and SSH (port 22) from anywhere.
Outbound Rule: All traffic allowed.
6. EC2 Instances (2)
Two EC2 instances are created in the public subnets (subnet1 and subnet2), each using a user data script (userdata1.sh and userdata2.sh) for initialization.
7. Application Load Balancer (ALB)
A public-facing ALB is created that listens on port 80 (HTTP). It is associated with the two public subnets and the security group project_sg.
8. Target Group for ALB
A target group is created to route traffic to the EC2 instances. The health check is set to the root path (/).
9. Listener for ALB
A listener is configured on the ALB that forwards incoming HTTP traffic on port 80 to the target group.
10. Output
The DNS name of the Load Balancer is displayed as an output (loadbalancerdns).

How to Use
1. Clone the Repository

git clone <repository-url>
cd <repository-directory>

2. Initialize Terraform
Run the following command to initialize Terraform and download the necessary provider plugins:

terraform init

3. Apply Terraform Configuration
Run the following command to apply the Terraform configuration:

terraform apply

You will be prompted to confirm the creation of resources. Type yes to proceed.

5. Check the Load Balancer DNS
After the resources are created, you can access the Load Balancer DNS by checking the output:

terraform output loadbalancerdns

5. Clean Up Resources
To destroy all the resources created by Terraform, run:

terraform destroy
Confirm by typing yes when prompted.

Conclusion
This Terraform configuration sets up a simple architecture in AWS with a VPC, subnets, EC2 instances, security groups, and an application load balancer. This setup can be used as a starting point for more complex AWS architectures and infrastructure management tasks.
