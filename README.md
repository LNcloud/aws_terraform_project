# Project: AWS Infrastructure with Terraform

This project demonstrates how to create an AWS infrastructure using Terraform. The infrastructure includes a VPC, subnets, security groups, EC2 instances, an Application Load Balancer (ALB), and associated resources.

## **Table of Contents**
1. [Components](#components)
2. [Prerequisites](#prerequisites)
3. [Instructions](#instructions)
4. [Outputs](#outputs)

---

## **Components**
### **1. VPC**
- A Virtual Private Cloud (VPC) with CIDR block defined by `var.vpc_cidr`.
- Associated subnets and an Internet Gateway (IGW).

### **2. Subnets**
- **Public Subnet 1**:
  - CIDR Block: `10.0.0.0/24`
  - Associated with `availability_zone` from `var.subnet1_az`.
  
- **Public Subnet 2**:
  - CIDR Block: `10.0.1.0/24`
  - Associated with `availability_zone` from `var.subnet2_az`.

### **3. Internet Gateway**
- Enables internet access for resources within the public subnets.

### **4. Route Table**
- Configures routes to direct internet-bound traffic through the Internet Gateway.

### **5. Security Group**
- Allows inbound traffic for HTTP (port 80) and SSH (port 22).
- Allows all outbound traffic.

### **6. EC2 Instances**
- **Web Server 1**:
  - Launched in Public Subnet 1.
  - Uses `userdata1.sh` for instance initialization.
- **Web Server 2**:
  - Launched in Public Subnet 2.
  - Uses `userdata2.sh` for instance initialization.

### **7. Application Load Balancer (ALB)**
- Routes HTTP traffic to the EC2 instances.
- Health check configured for root (`/`).

### **8. Target Group**
- Configures health checks and links EC2 instances to the ALB.

### **9. Outputs**
- Displays the DNS name of the ALB.

---

## **Prerequisites**
- Terraform installed on your local machine.
- AWS account with appropriate permissions.
- AWS CLI configured with credentials.

---

## **Instructions**

### **1. Clone the Repository**
Clone this repository to your local machine:
```bash
git clone https://github.com/LNcloud/aws_terraform_project.git
cd aws_terraform_project/
```

### **2. Configure Variables**
Ensure the following variables are set in a `variables.tf` file or as environment variables:
- `vpc_cidr`
- `subnet1_az`
- `subnet2_az`
- `ami_id`
- `instance_type`

### **3. Initialize Terraform**
Initialize Terraform to download necessary providers:
```bash
terraform init
```

### **4. Validate Configuration**
Validate the configuration to ensure there are no errors:
```bash
terraform validate
```

### **5. Plan the Deployment**
Review the planned infrastructure changes:
```bash
terraform plan
```

### **6. Apply the Deployment**
Deploy the infrastructure:
```bash
terraform apply
```
Type `yes` to confirm the deployment.

---

## **Outputs**
After successful deployment, Terraform will output the DNS name of the load balancer:
```plaintext
loadbalancerdns = <ALB_DNS_NAME>
```
You can access the application by visiting the DNS name in your web browser.

---

## **Notes**
- Ensure `userdata1.sh` and `userdata2.sh` scripts are present in the project directory.
- Delete resources after testing to avoid incurring unnecessary costs:
  ```bash
  terraform destroy
  ```

