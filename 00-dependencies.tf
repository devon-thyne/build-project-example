/*
  Filename: dependencies.tf
  Synopsis: Backend settings required to setup VPC
  Description: Declaration of providers and variables
*/


##### Backend

terraform {
    backend "s3" {
        encrypt = true

        # The remainder of the configurations are read in from backend.tfvars
        # For more detailed instructions on how to properly configure the backend, please refer to the README.md documentation.
    }
}



##### Providers

# AWS authentication information input through terraform.tfvars file
provider "aws" {
    access_key		= "${ var.access_key }"
    secret_key		= "${ var.secret_key }"
    region		= "${ var.aws_region }"
}

# Comment out the above provider block and comment in the below provider block if desired to used Terraform environment varibles for AWS authentication instead of .tfvars file method
//provider "aws" {}




##### Local Variables
# Defined IP address range for VPC
locals {
    vpc_cidr_block = "${ var.vpc_custom_octet }.0.0/16"
}

