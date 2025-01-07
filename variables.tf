variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnet1_cidr" {
  default     = "10.0.0.0/24"
  description = "CIDR block for Subnet 1"
}

variable "subnet2_cidr" {
  default     = "10.0.1.0/24"
  description = "CIDR block for Subnet 2"
}

variable "subnet1_az" {
  default     = "ap-south-1a"
  description = "Availability zone for Subnet 1"
}

variable "subnet2_az" {
  default     = "ap-south-1b"
  description = "Availability zone for Subnet 2"
}


variable "ami_id" {
  default     = "ami-053b12d3152c0cc71"
  description = "AMI ID for EC2 instances"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type for EC2 instances"
}
