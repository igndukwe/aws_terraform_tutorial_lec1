# create a VPC
resource "aws_vpc" "mtc_vpc" {
    cidr_block = "10.123.0.0/16"
    # read instructions on other attributes that must be avaliable before applying this
    #enable_dns_hostnames = ture
    #enable_dns_support = ture

    tags = {
        Name = "dev"
    }
}

# create a subnet resource
resource "aws_subnet" "mtc_public_subnet" {
    #reference the previous resource
    vpc_id = aws_vpc.mtc_vpc.id
    # this is one of the subnets within 10.123.0.0/16
    cidr_block = "10.123.1.0/24"
    # read instructions on other attributes that must be avaliable before applying this
    # map_public_ip_on_launch = ture
    # there are ways to use datasources here to ensure this is correct
    # especialy if you want to use multiple availability zones
    availability_zone = "us-west-2a"
    tags = {
        Name = "dev-public"
    }
}

# create an internet gateway
resource "aws_internet_gateway" "mtc_internet"