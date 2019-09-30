/*
  Filename: securitygroups.tf
  Synopsis: Security groups for the VPC
  Comments: N/A
*/


# Remove all rules from default security Group
resource "aws_default_security_group" "default_security_group" {
    vpc_id = "${ aws_vpc.vpc.id }"
    tags = {
        Name = "${ var.vpc_custom_name }-default-security-group"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
    }
}



##### Security Groups

# All-Egress
# Allows all outbound trafic for all VPC subnets
resource "aws_security_group" "security_group_egress" {
    vpc_id = "${ aws_vpc.vpc.id }"
    name = "${ var.vpc_custom_name }-egress-security-group"
    description = "Allows outbound traffic for ${ var.vpc_custom_name } VPC"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allows all outbound traffic for ${ var.vpc_custom_name } VPC subnets"
    }

    tags = {
        Name = "${ var.vpc_custom_name }-egress-security-group"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
    }
}



# Access-REDACTED-Networks
# Allows access from REDACTED Guest and REDACTED Corporate networks to the VPC via SSH and RDP
resource "aws_security_group" "security_group_access_REDACTED" {
    vpc_id = "${ aws_vpc.vpc.id }"
    name = "${ var.vpc_custom_name }-access-REDACTED-security-group"
    description = "Allows access from REDACTED Guest and REDACTED Corporate networks to ${ var.vpc_custom_name } VPC"

    ingress {
        protocol  = "tcp"
        from_port = 22
        to_port   = 22
        cidr_blocks = ["REDACTED/32"]
        description = "REDACTED Guest Wifi ingress to SSH"
    }

    ingress {
        protocol  = "tcp"
        from_port = 22
        to_port   = 22
        cidr_blocks = ["REDACTED/32"]
        description = "REDACTED Corp Wifi ingress to SSH"
    }

    ingress {
        protocol  = "tcp"
        from_port = 3389
        to_port   = 3389
        cidr_blocks = ["REDACTED/32"]
        description = "REDACTED Guest Wifi ingress to RDP"
    }

    ingress {
        protocol  = "tcp"
        from_port = 3389
        to_port   = 3389
        cidr_blocks = ["REDACTED/32"]
        description = "REDACTED Corp Wifi ingress to RDP"
    }

    tags = {
        Name = "${ var.vpc_custom_name }-access-REDACTED-security-group"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
    }
}



# Access-Intra-VPC
# Allows all communication within the VPC between instances
resource "aws_security_group" "security_group_vpc" {
    vpc_id = "${ aws_vpc.vpc.id }"
    name = "${ var.vpc_custom_name }-vpc-security-group"
    description = "Allows all communication within the ${ var.vpc_custom_name } VPC"

    ingress {
        protocol  = -1
        from_port = 0
        to_port   = 0
        cidr_blocks = ["${ local.vpc_cidr_block }"]
        description = "Allows traffic from ${ var.vpc_custom_name } ingress to all protocols and ports"
    }

    egress {
        protocol  = -1
        from_port = 0
        to_port   = 0
        cidr_blocks = ["${ local.vpc_cidr_block }"]
        description = "Allows traffic to ${ var.vpc_custom_name } egress to all protocols and ports"
    }
  
    tags = {
        Name = "${ var.vpc_custom_name }-vpc-security-group"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
    }
    lifecycle {
        ignore_changes = ["tags"]
    }
}

