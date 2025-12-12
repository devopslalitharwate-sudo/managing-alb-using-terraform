# alb
resource "aws_lb" "my-vpc-lb" {
  name               = "my-vpc-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets

  tags = {
    Environment = "my-vpc-lb"
  }
}

# target group
resource "aws_lb_target_group" "vpc-lb-target-group" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# target group attachment
resource "aws_lb_target_group_attachment" "test" {
  count = length(var.instance_id)
  target_group_arn = aws_lb_target_group.vpc-lb-target-group.arn
  target_id        = var.instance_id[count.index]
  port             = 80
}


#listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my-vpc-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpc-lb-target-group.arn
  }
}