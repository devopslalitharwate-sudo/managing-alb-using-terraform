output "instance_id" {
  value = aws_instance.my-vpc-ec2.*.id
}