/*
  Filename: keypairs.tf
  Synopsis: Management VPC Key Pairs
  Comments: N/A
*/


##### Upload key pairs only if conditional flag (var.key_pairs) is set to true. Default is false.


resource "aws_key_pair" "key_pair" {
    count = "${ var.aws_keypair ? 1 : 0 }"
    key_name = "${ var.vpc_custom_name }-ec2-keypair"
    public_key = "ssh-rsa PUBLICKEY EMAIL@REDACTED.com"
}

