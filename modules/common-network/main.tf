resource "aws_vpc" "goorm" {
  cidr_block = "10.9.0.0/16"
  tags = {
    Name = "goorm-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 0)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "goorm-public-subnet"
  }
}

resource "aws_subnet" "private-app" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 1)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "goorm-private-subnet-app"
  }
}

resource "aws_subnet" "private-db" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 2)
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "goorm-private-subnet-db"
  }
}

resource "aws_subnet" "private-db-2" {
  vpc_id            = aws_vpc.goorm.id
  cidr_block        = cidrsubnet(aws_vpc.goorm.cidr_block, 4, 3)
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "goorm-private-subnet-db-2"
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

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
# NOTE: "vic cidr -> local" route는 aws가 자동으로 생성/관리하므로 생략.

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

### Routing Table - Private - App ###
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.goorm.id
  tags = {
    Name = "goorm-rtb-private-app"
  }
}
resource "aws_route_table_association" "private_app_assoc" {
  subnet_id      = aws_subnet.private-app.id
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
resource "aws_network_acl_rule" "private_app_egress_allow_vpc" {
  network_acl_id = aws_network_acl.private_app.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = aws_vpc.goorm.cidr_block
}
# nacl <-> subnet 연결
resource "aws_network_acl_association" "private_app_assoc" {
  network_acl_id = aws_network_acl.private_app.id
  subnet_id      = aws_subnet.private-app.id
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