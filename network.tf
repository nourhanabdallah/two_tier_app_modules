#create resources

# create 2 private subnets
resource "aws_subnet" "private-subnet" {
    for_each = var.private-subnets

    availability_zone_id = each.value["availability_zone"]
    cidr_block = each.value["cidr"]
    vpc_id = data.aws_vpc.nour_vpc.id

    tags = {
        Name = "${var.naming}-${each.key}"
        }
    }


# create public subnet  

resource "aws_subnet" "public-subnet" {
    for_each = var.public-subnets

    availability_zone_id = each.value["availability_zone"]
    cidr_block = each.value["cidr"]
    vpc_id = data.aws_vpc.nour_vpc.id

    tags = {
    Name = "${var.naming}-${each.key}"
    }
}

#gateway

resource "aws_internet_gateway" "gw" {
    vpc_id = data.aws_vpc.nour_vpc.id


    tags = {
        Name = "nour-gw"
    }
    }

#route_table

resource "aws_route_table" "public_subnet_route_table" {
    vpc_id = data.aws_vpc.nour_vpc.id

    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = "nour-route_table"
    }
}


# associate route table to the public subnet 

resource "aws_route_table_association" "associate" {     
    for_each = aws_subnet.public-subnet 
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public_subnet_route_table.id
}


