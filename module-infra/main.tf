resource "aws_instance" "tool" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = []

  tags = {
    Name = var.name
  }
}


resource "aws_route53_record" "private" {
  zone_id = var.zone_id
  name = "${var.name}-${var.env}"
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



