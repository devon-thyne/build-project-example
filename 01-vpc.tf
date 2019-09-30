/*
  Filename: vpc.tf
  Synopsis: Creates the VPC
  Description: N/A
  Comments: N/A
*/


##### VPC Creation

resource "aws_vpc" "vpc" {
    cidr_block = "${ local.vpc_cidr_block }"
    instance_tenancy = "default"
    tags = {
        Name = "${ var.vpc_custom_name }"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
        prevent_destroy = false
    }
}

