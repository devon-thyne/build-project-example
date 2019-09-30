/*
  Filename: variables.tf
  Synopsis: Terraform input variables
  Description: Variables that should be changed on creation of a new VPC and related resources
  Comments: N/A
*/


##### Dynamic Terraform Variables

# To be changed to reflect the current user of this terraform module
variable "build_user" {
    description = "Defines the BuildUser for all resources and aids in pathing for backend configurations"
}

# Examples: 'test-bob', 'test-bob', 'build-REDACTED', or 'REDACTED-management'
variable "vpc_custom_name" {
    description = "Defines the name of the VPC. Note, all other resources are going to be named and/or tagged off of this value"
}

# Please see 'Turn features on/off' section below for dynamically handling instances and key pairs



##### AWS Authentication Variables

# If you desire to have terraform read aws credentials from your environment varibles, please comment out these two variables

# Please see README.md file for details on how to populate the terraform.tfvars file.
variable "access_key" {
    description = "AWS account access key read in from terrafrom.tfvars file by default"
}
variable "secret_key" {
    description = "AWS account secret key read in from terrafrom.tfvars file by default"
}



##### AWS Variables

variable "aws_region" {
    default = "REDACTED"
    description = "AWS Region"
}


##### VPC Variables

variable "vpc_custom_octet" {
    default = "10.222"
    description = "Defines the internal ip range for the VPC"
}



##### Turn features on or off

variable "aws_instances" {
    type = bool
    default = false
    description = "Conditional flag to tell terraform to spin up instances or not. Default is to not spin them up (false)"
}

variable "aws_keypair" {
    type = bool
    default = false
    description = "Conditional flag to tell terraform to generate key pairs or not. Default is to not generate them (false)"
}

# Note, the conditional flag above 'aws_keypair' must be set to 'false' in order to use an existing key pair name
variable "existing_aws_keypair_name" {
    default = ""
    description = "Stores the value of an existing AWS key pair's name if the user wishes to spin up instances with an existing key pair instead of generating a new one."
}

