#  creating a security group that allow  http, https

resource "aws_security_group" "SG-RDS" {
    name        = "nour-security-group2"
    description = "Allow RDS traffic"
    vpc_id = data.aws_vpc.nour_vpc.id



#  allow https, http inbound traffic
    ingress {
        description      = "RDS"
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


#  allow all outbound traffic from the ec2 instance
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    } 

tags = {
    Name = "allow_RDS-nour"
    }
}

# create an RDS instance inside our VPC

resource "aws_db_subnet_group" "my_db_subnet_group" {
    name       = "nour_db_subnet_group"
    subnet_ids =  [aws_subnet.private-subnet["private-sub-1"].id,aws_subnet.private-subnet["private-sub-2"].id ]




    tags = {
    Name = "nour-subnet-group"
    }

}


resource "aws_db_instance" "nour_instance" {
    engine                = "mysql"
    engine_version        = "5.7"
    instance_class        = "db.t2.micro"
    allocated_storage     = 20
    db_name               = "nour_instance"
    username              = "nour_user"
    password              = "nour_password"
    db_subnet_group_name  = aws_db_subnet_group.my_db_subnet_group.name
    final_snapshot_identifier = "terraform-20230305123422738100000001finalsnapshot"
    vpc_security_group_ids = [aws_security_group.SG-RDS.id]
    skip_final_snapshot  = true
    multi_az = true

    port = 3306
}
