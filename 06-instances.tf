/*
  Filename: instances.tf
  Synopsis: Spin up VPC Instances
  Comments: N/A
*/


##### Find the latest RHEL 7.6 Base image
data "aws_ami" "rhel7_6" {
    most_recent = true
    filter {
        name = "name"
        values = ["REDACTED"]
    }
    owners = ["REDACTED"] # Owned by Bob
}



##### Spin up instances only if conditional flag (var.instances) is set to true. Default is false.

# Sample Instance
resource "aws_instance""instance-RHEL7_6" {
    count = "${ var.aws_instances ? 1 : 0 }"
    ami = "${ data.aws_ami.rhel7_6.image_id }"
    instance_type = "t2.micro"
    tags = {
        Name = "${ var.vpc_custom_name }-RHEL7_6-Jumpbox-1"
        Managed-By = "Terraform"
        ProvisionDate = "${ timestamp() }"
        BuildUser = "${ var.build_user }"
        Business: "REDACTED"
        Platform: ""
        Account: ""
        OperatingSystem: "RHEL 7.6"
        Image: "${ data.aws_ami.rhel7_6.name }"
        Description: "Test RHEL 7.6 Jumpbox"
        Domain: ""
        Environment: ""
        Hostname: ""
        ProductName: ""
        PatchGroup: ""
        Generated-By: "Terraform"
    }
    vpc_security_group_ids = ["${aws_security_group.security_group_vpc.id}","${aws_security_group.security_group_egress.id}","${aws_security_group.security_group_access_REDACTED.id}"]
    subnet_id = "${ aws_subnet.subnet_1a.id }"
    key_name = "${ var.aws_keypair ? aws_key_pair.key_pair[count.index].key_name : var.existing_aws_keypair_name }"
    associate_public_ip_address = true
    lifecycle {
        ignore_changes = ["ami","tags"]
        prevent_destroy = false
    }
}

