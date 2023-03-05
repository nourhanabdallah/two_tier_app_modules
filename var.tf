#define variables

variable "vpc_id" {
type=string
}
variable "naming" {
type=string
}

#Data Source: aws_vpcs

data "aws_vpc" "nour_vpc" {
id = var.vpc_id
}



#maping subnets 

variable "private-subnets" {
    type = map
    default = {
        private-sub-1 = {
        availability_zone = "usw1-az1"
        cidr = "192.168.101.32/28"
        }
        private-sub-2 = {
        availability_zone= "usw1-az3"
        cidr = "192.168.101.64/28"
        }
    }
}


variable "public-subnets" {
    type = map
    default = {
        public-sub = {
        availability_zone= "usw1-az1"
        cidr = "192.168.101.0/28"
    }
    }
}


