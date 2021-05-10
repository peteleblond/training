#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-e613ac89
#
# Your subnet ID is:
#
#     subnet-513a262b
#
# Your security group ID is:
#
#     sg-1cbf1176
#
# Your Identity is:
#
#     terraform-training-butterfly
#

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  type    = "string"
  default = "eu-central-1"
}

variable "instancecount" {
  type    = "string"
  default = "3"
}

#variable "dnsimple_token" {
#  type = "string"
#  default = "default-token"
#}

#variable "dnsimple_account" {
#  type = "string"
#  default = "default-account"
#}

#variable "dnsimple_domain" {
#  type = "string"
#  default = "default-domain"
#}


# Terraform Enterprise
terraform {
 backend "atlas" {
  name = "peteleblond/training"
 }
}


# Providers
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

#provider "dnsimple" {
#  token = "${var.dnsimple_token}"
#  account = "${var.dnsimple_account}"
#}


resource "aws_instance" "web" {
  ami                    = "ami-e613ac89"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-513a262b"
  vpc_security_group_ids = ["sg-1cbf1176"]

  tags {
    Identity = "terraform-training-butterfly"
    TagA     = "ValueA"
    TagB     = "ValueB"
    Name     = "Web ${count.index + 1}/${var.instancecount}"
  }

  count = "${var.instancecount}"
}


#resource "dnsimple_record" "Web-1" {
#  domain = "${var.dnsimple_domain}"
#  name   = "web-1"
#  value  = "${aws_instance.web.0.public_ip}"
#  type   = "A"
#  ttl    = 3600
#}


output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
