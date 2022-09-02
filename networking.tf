# networking.tf | Network Configuration

#internet gateway
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-igw"
    Environment = var.app_environment
  }
}

#public subnets
resource "aws_subnet" "aws-public-subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

#public route table 
resource "aws_route_table" "aws-public-route-table" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-public-route-table"
    Environment = var.app_environment
  }
}

#any address that is not local should go to internet gateway
resource "aws_route" "aws-public-route" {
  route_table_id         = aws_route_table.aws-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}

## associate the route table with all the public subnets
resource "aws_route_table_association" "aws-public-route-table-association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.aws-public-subnets.*.id, count.index)
  route_table_id = aws_route_table.aws-public-route-table.id
}
