

resource "aws_security_group" "demo_sg" {
  name = var.sg_name
  description = var.sg_name
  vpc_id = var.vpc_id

}

resource "aws_instance" "demo_instance" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.public_subnet_id
}
