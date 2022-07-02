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
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# create a route table
resource "aws_route_table" "mtc_public_rt" {
    vpc_id = aws_vpc.mtc_vpc.id

    tags = {
        Name = "dev-public-rt"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.mtc_public_rt.id
    # all ip addresses will head to this internet getway
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mtc_internet_gateway.id
}

# Associate your subnet with the route table
resource "aws_route_table_association" "mtc_public_assoc" {
    subnet_id = aws_subnet.mtc_public_subnet.id
    #vpc_id = aws_vpc.mtc_vpc.id
    route_table_id = aws_route_table.mtc_public_rt.id
}

# Create your security group
resource "aws_security_group" "mts_sg" {
  name        = "dev_gs"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    # enter your IP addresses here
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    # I what whatever goes into the subnet to access the open
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# create an ssh key to connect
# use the terraform file() function to enter the directory of the public key
# instead of copying it and pasting
resource "aws_key_pair" "mtc_auth" {
    key_name = "mtckey"
    public_key = file("~/.ssh/terraform_mtc_key.pub")
}

# create an aws instance
resource "aws_instance" "dev_node" {
    # you can scale this up but that might cost some more money
    instance_type = "t2.micro"
    key_name = aws_key_pair.mtc_auth.id
    vpc_security_group_ids = [aws_security_group.mts_sg.id]
    subnet_id = aws_subnet.mtc_public_subnet.id

    # remember that terraform reads all the .tf files as once source
    # Hence data.aws_ami.server_ami is found in the datasource.tf file
    ami = data.aws_ami.server_ami.id

    # resize the default size of the drive on this instance
    # from default of 8 to 10
    # t2.micro will give a max of 16
    root_block_device {
        volume_size = 10
    }
    
    tags = {
        Name = "dev-node"
    }
}