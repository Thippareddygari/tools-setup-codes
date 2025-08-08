resource "aws_security_group" "tool_sg" {
  name = "${var.name}-sg"
  description = "${var.name} Security group"

  tags = {
    Name =  "${var.name}-sg"
  }

}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tool_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_port" {
  security_group_id = aws_security_group.tool_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.port
  to_port = var.port
  ip_protocol = "tcp" 
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tool_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
}


resource "aws_instance" "tool" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool_sg.id]

  tags = {
    Name = var.name
  }
}


resource "aws_route53_record" "private" {
  zone_id = var.zone_id
  name = "${var.name}-private"
  type="A"
  ttl =10
  records  = [aws_instance.tool.private_ip]
}

resource "aws_route53_record" "publlic" {
  zone_id = var.zone_id
  name= "${var.name}"
  type= "A"
  ttl = 10
  records = [aws_instance.tool.public_ip]
}



