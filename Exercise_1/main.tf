# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
    access_key = "##redacted##"
    secret_key = "##redacted##"
    region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "UdT2" {
    ami = "ami-08e4e35cccc6189f4"
    instance_type = "t2.micro"  
    count = "4"
    tags = {
        Name = "Udacity T2"
    }
    subnet_id = "subnet-03e1d8c2af64812e0"
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
#resource "aws_instance" "UdM4" {
#    ami = "ami-08e4e35cccc6189f4"
#    instance_type = "m4.large"  
#    count = "2"
#    tags = {
#        Name = "Udacity M4"
#    }
#    subnet_id = "subnet-03e1d8c2af64812e0"
#}