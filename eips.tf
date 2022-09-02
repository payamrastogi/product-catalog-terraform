resource "aws_eip" "aws-eips" {
  count      = length(var.public_subnets)
  vpc        = true
  depends_on = [aws_internet_gateway.aws-igw]
}

resource "aws_nat_gateway" "aws-nat-gateways" {
  count         = length(var.public_subnets)
  subnet_id     = element(aws_subnet.aws-public-subnets.*.id, count.index)
  allocation_id = element(aws_eip.aws-eips.*.id, count.index)
  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-natgw-${count.index + 1}"
    Environment = var.app_environment
  }
}

## private subnets
resource "aws_subnet" "aws-private-subnets" {
  vpc_id            = aws_vpc.aws-vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_environment}-${var.app_name}-${var.service_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

resource "aws_route_table" "private-aws-route-table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.aws-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.aws-nat-gateways.*.id, count.index)
  }
}

resource "aws_route_table_association" "private-aws-route-table-association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.aws-private-subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private-aws-route-table.*.id, count.index)
}