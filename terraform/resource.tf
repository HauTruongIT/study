# VPC
resource "aws_vpc" "st-vpc" {
    cidr_block          = var.AWS_CIDR["vpc"]
    instance_tenancy    = "default"
    tags = {
        Name = "st-vpc"
    }
}

# Subnets
resource "aws_subnet" "st-subnet-public" {
    vpc_id                  = aws_vpc.st-vpc.id
    cidr_block              = var.AWS_CIDR["subnet_public"]
    availability_zone       = var.AWS_AZ
    map_public_ip_on_launch = true
    tags = {
        Name = "st-subnet-public"
    }
}

resource "aws_subnet" "st-subnet-private" {
    vpc_id                  = aws_vpc.st-vpc.id
    cidr_block              = var.AWS_CIDR["subnet_private"]
    availability_zone       = var.AWS_AZ
    map_public_ip_on_launch = false
    tags = {
        Name = "st-subnet-private"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "st-gw" {
    vpc_id = aws_vpc.st-vpc.id
    tags = {
        Name = "st-gw"
    }
}

# Route Table Public
resource "aws_route_table" "st-route-public" {
    vpc_id = aws_vpc.st-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.st-gw.id
    }
    tags = {
        Name = "st-route-public"
    }
}

# Route Table Association Public
resource "aws_route_table_association" "st-ass-public" {
    subnet_id       = aws_subnet.st-subnet-public.id
    route_table_id  = aws_route_table.st-route-public.id
}

# Elastic IP
resource "aws_eip" "st-elastic-ip" {
    vpc = true
    tags = {
        Name = "st-elastic-ip"
    }
}

# Nat Gateway
resource "aws_nat_gateway" "st-nat-gw" {
    allocation_id = aws_eip.st-elastic-ip.id
    subnet_id = aws_subnet.st-subnet-public.id
    tags = {
        Name = "st-nat-gw"
    }
}

# Route Table Private
resource "aws_route_table" "st-route-private" {
    vpc_id = aws_vpc.st-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.st-nat-gw.id
    }
    tags = {
        Name = "st-route-private"
    }
}

# Instance in Public Subnet
resource "aws_instance" "st-ec2-public" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.st-subnet-public.id
    tags = {
        Name = "st-ec2-public"
    }
}

# Instance in Private Subnet
resource "aws_instance" "st-ec2-private" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.st-subnet-private.id
    tags = {
        Name = "st-ec2-private"
    }
}
