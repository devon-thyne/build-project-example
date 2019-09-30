/*
  Filename: gateways.tf
  Synopsis: Create the Internet Gateway for the VPC
  Comments: N/A
*/


##### Create the Internet Gateway

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${ aws_vpc.vpc.id }"
    tags = {
        Name = "${ var.vpc_custom_name }-default-internet-gateway"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
    }
}

