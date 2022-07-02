# create ubutu ec2 instance
data "aws_ami" "server_ami"{
    most_recent      = true
    # you can find this id from the 
    # ec2 server you choos to use 
    # we are using ubuntu 
    owners = ["099720109477"]

    filter {
        name   = "name"
        #ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20220610
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
}