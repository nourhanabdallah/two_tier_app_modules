#  creating a security group to allow  traffic

resource "aws_security_group" "SG-web" {
    name        = "nour-security-group1"
    description = "Allow http and https inbound traffic"

    vpc_id = data.aws_vpc.nour_vpc.id



#  allow https, http inbound traffic
    ingress {
    description      = "HTTPS "
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }


#  allow all outbound traffic 
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    } 

    tags = {
    Name = "allow_http_https-nour"
    }
}



# creating an EC2 

resource "aws_instance" "instance" {
    ami           = "ami-060d3509162bcc386"
    instance_type = "t2.micro"


    vpc_security_group_ids = [aws_security_group.SG-web.id]

    subnet_id = aws_subnet.public-subnet["public-sub"].id

#  here is my key-pair that used to authentication when access this instance by ssh
    key_name = "nour-keyssh"

#   the instance name 
    tags = {
        Name = "web-instance-nour"
    }
}

# Generate an EIp elastic public ip 
resource  "aws_eip" "my-eip"{
    instance = aws_instance.instance.id
    vpc = true
    
}