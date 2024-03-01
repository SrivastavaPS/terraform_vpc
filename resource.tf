resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "PS_VPC"
  }
}

resource "aws_subnet" "private1" {  
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Private_VPC_1"
  }
}

resource "aws_subnet" "private2" {  
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Private_VPC_2"
  }
}

resource "aws_subnet" "public1" {  
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "Public_VPC_1"
  }
}

resource "aws_subnet" "public2" {  
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/24"
  tags = {
    Name = "Public_VPC_2"
  }
}


resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myPS_IG"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIG.id
  }

  tags = {
    Name = "My_PS_Public_RT"
  }
}

resource "aws_route_table_association" "public1_1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public1_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_eip" "myeip" {
    public_ipv4_pool  = "amazon"
}

resource "aws_security_group" "mysg" {
  name        = "myPS_SG"
  description = "Allow SSH and HTTP inbound traffic"

  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "os1" {
  ami           =  "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "ps_virginia"
  tags          = {
    Name = "Prateek"
  }
  subnet_id = aws_subnet.public1.id
  vpc_security_group_ids  = [aws_security_group.mysg.id]
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.os1.id
  allocation_id = aws_eip.myeip.id
}
