/*
  Filename: outputs.tf
  Synopsis: Outputs of the Module
  Description: Output commonly used values of the VPC
  Comments: N/A
*/


##### VPC

output "vpc_name" { value = "${aws_vpc.vpc.tags.Name}" }
output "vpc_id" { value = "${aws_vpc.vpc.id}" }



##### Subnets

output "subnet_1a_name" { value = "${aws_subnet.subnet_1a.tags.Name}" }
output "subnet_1a_id" { value = "${aws_subnet.subnet_1a.id}" }
output "subnet_1b_name" { value = "${aws_subnet.subnet_1b.tags.Name}" }
output "subnet_1b_id" { value = "${aws_subnet.subnet_1b.id}" }



##### Security Groups

output "sg_egress_id" { value = "${aws_security_group.security_group_egress.id}" }
output "sg_access-REDACTED_id" { value = "${aws_security_group.security_group_access_REDACTED.id}" }
output "sg_vpc_id" { value = "${aws_security_group.security_group_vpc.id}" }



##### Gateways

output "igw_id" { value = "${ aws_internet_gateway.internet_gateway.id }" }

