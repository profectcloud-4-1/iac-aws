resource "aws_vpc" "goorm" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "goorm-vpc"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 0)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "goorm-public-subnet"
    "kubernetes.io/role/elb" = "1"
  }
}
resource "aws_subnet" "public-b" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 5)
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "goorm-public-subnet-b"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private-app-a" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 1)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name                              = "goorm-private-subnet-app-a"
    AZ                                = "a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/goorm"     = "shared"
  }
}
resource "aws_subnet" "private-app-b" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 2)
  availability_zone = "ap-northeast-2b"
  tags = {
    Name                              = "goorm-private-subnet-app-b"
    AZ                                = "b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/goorm"     = "shared"
  }
}

resource "aws_subnet" "private-db" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 3)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "goorm-private-subnet-db-a"
    AZ   = "a"
  }
}

resource "aws_subnet" "private-db-2" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 4)
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "goorm-private-subnet-db-b"
    AZ   = "b"
  }
}

# Internet Gateway (퍼블릭 서브넷 인터넷 통신용)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-igw"
  }
}


### Routing Table - Public ###
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-rtb-public"
  }
}

resource "aws_route" "public_internet_a" {
  route_table_id         = aws_route_table.public-a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
# NOTE: "vic cidr -> local" route는 aws가 자동으로 생성/관리하므로 생략.

resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_b" {
  route_table_id         = aws_route_table.public-b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
# NOTE: "vic cidr -> local" route는 aws가 자동으로 생성/관리하므로 생략.

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public.id
}

### Routing Table - Private - App ###
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-rtb-private-app"
  }
}
resource "aws_route_table_association" "private_app_a_assoc" {
  subnet_id      = aws_subnet.private-app-a.id
  route_table_id = aws_route_table.private_app.id
}
resource "aws_route_table_association" "private_app_b_assoc" {
  subnet_id      = aws_subnet.private-app-b.id
  route_table_id = aws_route_table.private_app.id
}

### Routing Table - Private - DB ###
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-rtb-private-db"
  }
}
resource "aws_route_table_association" "private_db_assoc" {
  subnet_id      = aws_subnet.private-db.id
  route_table_id = aws_route_table.private_db.id
}

### Network ACL - Private - App ###
resource "aws_network_acl" "private_app" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-nacl-private-app"
  }
}
resource "aws_network_acl_rule" "private_app_ingress_allow_vpc" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
}
resource "aws_network_acl_rule" "private_app_ingress_allow_ephemeral_ports" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 200
  egress         = false
  from_port      = 1024
  to_port        = 65535
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
resource "aws_network_acl_rule" "private_app_egress_allow_vpc" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
}
resource "aws_network_acl_rule" "private_app_egress_allow_https" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 110
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
resource "aws_network_acl_rule" "private_app_egress_allow_http" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 120
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}
resource "aws_network_acl_rule" "private_app_egress_allow_db_rds" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 140
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
  from_port      = 5432
  to_port        = 5432
}
resource "aws_network_acl_rule" "private_app_egress_allow_db_redis" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 150
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
  from_port      = 6379
  to_port        = 6379
}
# nacl <-> subnet 연결
resource "aws_network_acl_association" "private_app_a_assoc" {
  network_acl_id = aws_network_acl.private_app.id
  subnet_id      = aws_subnet.private-app-a.id
}
resource "aws_network_acl_association" "private_app_b_assoc" {
  network_acl_id = aws_network_acl.private_app.id
  subnet_id      = aws_subnet.private-app-b.id
}

### Network ACL - Private - DB ###
resource "aws_network_acl" "private_db" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-nacl-private-db"
  }
}
resource "aws_network_acl_rule" "private_db_ingress_allow_vpc" {
  network_acl_id = aws_network_acl.private_db.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
}
resource "aws_network_acl_rule" "private_db_egress_allow_vpc" {
  network_acl_id = aws_network_acl.private_db.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
}
# nacl <-> subnet 연결
resource "aws_network_acl_association" "private_db_assoc" {
  network_acl_id = aws_network_acl.private_db.id
  subnet_id      = aws_subnet.private-db.id
}

# eip for nat gw
resource "aws_eip" "nat" {
  tags = {
    Name = "goorm-nat-eip"
  }
}

# nat gw
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "goorm-nat-gateway"
  }
}

resource "aws_route" "private_app_to_nat" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
