#1 Creating the VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-vpc"
        Environment = var.environment
    }
}

#2 Internet Gateway (for Public subnets)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
    }   
}

#3 Public subnets
resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-${count.index + 1}"
        #Required for EKS to create public load balancers
        "kubernetes.io/role/elb" = "1"
    }
}

#4 Private subnets
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.project_name}-private-${count.index + 1}"
        #Required for EKS to create internal load balancers
        "kubernetes.io/role/internal-elb" = "1"
    }
} 

#5 NAT Gateway (for Private subnets to access internet)
# We will need an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-nat-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id # Placing NAT in the first public subnet

    tags = {
        Name = "${var.project_name}-nat"    
    }

    depends_on = [aws_internet_gateway.igw]
}

#6 Route Tables
# Public Route Table (Traffic -> IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Private Route Table (Traffic -> NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

#7 Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}