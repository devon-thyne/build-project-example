Build Project Example Module
============================

This space includes Terraform code to setup and configure an example Terraform project. This is done fully declarative and aids in the process of generating a fresh VPC along with all resources needed to support it.

Dependencies
------------

* Terraform 0.12
* AWS Administrator level privileges or privileges to manage VPC, EC2, S3, and DynamoDB
* AWS cli properly configured with the correct access keys for the target account. This can be easily reconfigured using command `aws configure`
* AWS S3 bucket to store the terraform statefile. For this documentation we will use `S3-BUCKET-NAME` but it is expected that you change this to you intended value. To help, below is example syntax for AWS CLI commands to create an S3 bucket programmatically:
    ```
    aws s3api create-bucket --bucket S3-BUCKET-NAME --region REDACTED --create-bucket-configuration LocationConstraint=REDACTED
    aws s3api put-public-access-block --bucket S3-BUCKET-NAME --public-access-block BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
    ```

* AWS DynamoDB to store the locking information for the terraform statefile stored in `S3-BUCKET-NAME`. For this documentation we will use `DYNAMODB-TABLE-NAME` Note, the table's Primary Partition Key must be set to `LockID` (String). This is vital to enabling locking on the terraform state. To help, below is example syntax for AWS CLI commands to create a DynamoDB table programmatically:
    ```
    aws dynamodb create-table --table-name DYNAMODB-TABLE-NAME --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
    ```

Setup of Build Project VPC
==========================

When running on a new aws account the following steps should be taken:

1. Clone REDACTED-terraform repository. This repository can be accessed through both the build GitLab server as well as the dev GitHub.
```
git clone REDACTED
```
or
```
git clone REDACTED
```

2. Change your working directory into the repository you just cloned within the modules directory.
```
cd REDACTED-terraform/modules
```

3. Use `build-project-example` module to create new project module; name project accordingly.
```
cp build-project-example YOUR-PROJECT-NAME
```

4. Change your working directory into the new project directory you just created.
```
cd YOUR-PROJECT-NAME
```

5. Copy the terraform template file `terraform.tfvars.template` that has been provided as a starting point and populate its contents accordingly.
```
cp terraform.tfvars.template terraform.tfvars
```

6. Populate terraform.tfvars file with AWS access key and secret key.
```
access_key = "YOUR AWS ACCOUNT ACCESS KEY"
secret_key = "YOUR AWS ACCOUNT SECRET KEY"
```

7. Copy the backend template file `backend.tfvars.template` that has been provided as a starting point and populate its contents accordingly.
```
cp backend.tfvars.template backend.tfvars
```

8. Populate backend.tfvars file described in 5. with redundant AWS credentials as well as configuration information for storing the terraform state file. Note, to avoid stomping on others' state files, it is a good idea to have the directory where the `key` is being stored contain your userID in the name to assure that it is a unique location.
```
##### AWS Authentication credentials
access_key = "SAME ACCESS KEY AS ABOVE in #4"
secret_key = "SAME SECRET KEY AS ABOVE in #4"
##### Terraform s3 backend configuration
region = "AWS REGION"
bucket = "S3-BUCKET-NAME"
dynamodb_table = "DYNAMODB-TABLE-NAME"
key = "PATH/TO/FILENAME.tfstate"
```
```
EXAMPLE FILE CONTENTS:
##### AWS Authentication credentials
access_key = "abc123"
secret_key = "abc123"
##### Terraform s3 backend configuration
region = "REDACTED"
bucket = "build-project00"
dynamodb_table = "bob-build-project00"
key = "bob/build-project00.tfstate"
```

9. Open build project variables file
```
vi 00-variables.tf
```

10. Adjust value for `build_user` to reflect the current user configuring the terraform module
```
EXAMPLE:
    variable "build_user" {
        default = "bob6"
        description = "Defines the BuildUser for all resources and aids in pathing for backend configurations"
    }
```

11. Adjust value for `vpc_custom_name` to reflect the name of our new VPC. Please note that conventionally it is good practice to append `test-iNUMBER` at the beginning of the VPC name during a development and testing phase.
```
Examples: 'test-ic12345', 'test-i45678', 'REDACTED-management', or 'REDACTED-management'
    variable "vpc_custom_name" {
        default = "YOUR VPC NAME"
        description = "Defines the name of the VPC. Note, all other resources are going to be named and/or tagged off of this value"
    }
```

12. Adjust values for `aws_region` and `vpc_custom_octet` to match desired aws region and ip address space
```
EXAMPLES:
    variable "aws_region" {
        default = "REDACTED"
        description = "AWS Region"
    }
    variable "vpc_custom_octet" {
        default = "10.222"
        description = "Defines the internal ip range for the VPC"
    }
```

13. Set `default` values for conditional flags `aws_instances`, `aws_keypair` and/or `existing_aws_keypair_name`.
    * If you wish to have terraform spin up new instances, manually set `aws_instances` to `true`, otherwise terraform will ignore any instances defined in `06-instances.tf`.
    * For details about SSH key generation/management, please see the `Generate New SSH` or `Use Existing SSH Key` sections below.

14. Commence to creating your VPC additional resources if necessary in all file. Main focuses are:
    * Additional/changes to IP traffic routing in the routes.tf file if needed
    * Additional/changes to security groups in security-groups.tf file if needed
    * Defining of AWS instances in instance.tf file if needed when the flag `aws_instances` in `00-variables.tf` file is set to true
    * Defining of AWS key pairs in key-pairs.tf file if needed when the flag `aws_keypair` in `00-variables.tf` file is set to true

15. Once satisfied with changes, save locally and commit changes to git. **Create merge request and receive approval before proceeding**
16. Initialize Terraform with specific backend pointing to backend.tfvars file. **Do not** execute without the `--backend.tfvars` file or you will be prompted for all the information via the command line intended to be contained within the file.
```
terraform init -backend-config=backend.tfvars
```

17. Review Terraform plan
```
terraform plan
```

18. Apply Terraform changes and confirm with `yes`
```
terraform apply
```

Generate New SSH Key
--------------------

1. If the user decides they want to generate a new keypair, the `aws_keypair` conditional flag `default` must be set to `true`. This will make it so each new instance will be spun up with the key pair defined in the `07-keypairs.tf` file instead of using the variable to store an existing key pair name `existing_aws_keypair_name`. When generating a new key pair, the steps are as follows:
2. Manually generate a new key pair. You may decide to name it however you choose and decide whether or not to give it a passphrase.
```
ssh-keygen -t rsa
```

3. Whatever the name specified for the new keypair in whatever directory it was chosen to be stored in, please file the file with the chosen `FILENAME.pub`. Copy and paste the contents of this file into the terraform attribute `public_key`.
```
resource "aws_key_pair" "key_pair" {
    count = "${ var.aws_keypair ? 1 : 0 }"
    key_name = "${ var.vpc_custom_name }-ec2-keypair"
    public_key = "PASTE FILE CONTENTS HERE"
}
```

Use Existing SSH Key
--------------------

If the user decides that they want to use an existing AWS keypair, the `aws_keypair` conditional flag `default` it to be left as `false`. This will ensure that any new key pair resource defined in the 07-keypairs.tf file will be ignored, and all new instances will be spun up using the exiting key pair as defined in variable `existing_aws_keypair_name`.

```
variable "existing_aws_keypair_name" {
    default = ""
    description = "Stores the value of an existing AWS key pair's name if the user wishes to spin up instances with an existing key pair instead of generating a new one."
}
```

Build Project Example Module Details
====================================

The following are a details concerning the Build Project Example. As an example project, many resources are conventionally tagged with the user's identifying information as a prefix. This documentation will use generically 'userid' to represent this.

### Subnets

| Terraform name  | AWS Tag Name       | CIDR         | Comments                       |
| --------------- | ------------------ | ------------ | -------------------------------|
| subnet_1a       | userid-az1a-subnet | x.x.16.0/24  | Subnet for availability zone A |
| subnet_1b       | userid-az1b-subnet | x.x.32.0/24  | Subnet for availability zone B |

### Security Groups

| Terraform Name              | AWS Tag Name                      | Comments                                                       |
| --------------------------- | --------------------------------- | -------------------------------------------------------------- |
| default_security_group      | userid-default-security-group     | AWS Default Security Group. Rules set to blank state           |
| security_group_egress       | userid-egress-security-group      | Allows all outbound traffic for VPC subnets                    |
| security_group_access_REDACTED   | userid-access-REDACTED-security-group  | Allows access from REDACTED Guest and REDACTED Corporate networks to VPC |
| security_group_vpc          | userid-vpc-security-group         | Allows traffic within the VPC                                  |

Destroying the VPC
==================

To destroy the entire VPC the following command is used:
```
terraform destroy
```

In some scenarios, it might be useful to know how to fully cleanup or start fresh with an existing Terraform configuration. If you have already run `terraform init` at any point, it can be tricky making certain changes. If you wish to keep your existing configuration files by initialize the project completely fresh, use the following steps:

1. Remove the generated `.terraform/` directory
```
rm -R .terraform
```

2. If you did not configure a remote backend for Terraform statefile previously, you might have a `terraform.tfstate` and `terraform.tfstate.backup` file. These also should be removed to fully cleanup.
```
rm terraform.tfstate
rm terraform.tfstate.backup
```

Author Information
------------------

* Devon Thyne (devon-thyne)
