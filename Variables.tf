
variable "region" {
  default = "eu-west-2"
  description = "AWS Region"
}

# Creating variables for VPC CIDR block.
variable "cidr_block" {
  default = "10.0.0.0/16"
  description = "VPC cidr_block"
}

# Creating variables for public Subnets

variable "pub-sub1-cidr_block" {
  default = "10.0.5.0/24"
  description = " Prod-pub-sub1"
}

variable "pub-sub2-cidr_block" {
  default = "10.0.6.0/24"
  description = "Public Subnet2"
}

# Creating variables for private Subnets

variable "prod-priv-sub1-cidr_block" {
  default = "10.0.7.0/24"
  description = "Private Subnet1"
}

variable "prod-priv-sub2-cidr_block" {
  default = "10.0.8.0/24"
  description = "Private Subnet2"
}

# creating variables for Internet Gateway

variable "IG-cidr_block" {
  default = "0.0.0.0/0"
  description = "Internet-Gateway"
}

# Creating variables for EC2 Instance

variable "ami" {
    default = "ami-0ad97c80f2dfe623b"
    description = "Instance Image"   
}

variable "instance_type" {
    default = "t2.micro"
    description = "instance type"
}

variable "key_name" {
    default = "rock-key-pair"
    description = "instance type"
}

variable "subnet_id" {
        description = "The VPC subnet the instance(s) will be created in"
        default = "subnet-07ebbe60"
}