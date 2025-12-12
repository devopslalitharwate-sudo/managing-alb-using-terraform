resource "aws_instance" "my-vpc-ec2" {
  count = length(var.subnet_id)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet_id[count.index]
  vpc_security_group_ids = [var.sg_id]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  user_data = file("${path.module}/user_data.sh")
  tags = {
    Name = "my-vpc-ec2-${count.index + 1}"
  }
}