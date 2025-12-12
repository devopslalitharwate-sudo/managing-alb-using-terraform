resource "aws_instance" "my-vpc-ec2" {
  count = length(var.subnet_id)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id = var.subnet_id[count.index]
  vpc_security_group_ids = [var.sg_id]
  availability_zone = data.aws_availability_zones.available.names[count.index]
user_data = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y apache2

systemctl enable apache2
systemctl start apache2

HOSTNAME=$(hostname)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

cat <<HTML >/var/www/html/index.html
<html>
<body>
  <h1>EC2 Instance Info</h1>
  <ul>
    <li><strong>Hostname:</strong> $HOSTNAME</li>
    <li><strong>Instance ID:</strong> $INSTANCE_ID</li>
    <li><strong>Private IP:</strong> $PRIVATE_IP</li>
    <li><strong>Availability Zone:</strong> $AZ</li>
    <li><strong>Region:</strong> $REGION</li>
  </ul>
</body>
</html>
HTML
EOF



  tags = {
    Name = "my-vpc-ec2-${count.index + 1}"
  }
}