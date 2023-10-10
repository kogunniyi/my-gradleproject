# create production loadbalancer
resource "aws_lb" "prod-lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.sg]

  tags = {
    Name = var.name
  }
}
resource "aws_lb_target_group" "prod-tg" {
  name     = var.name2
  port     = 30002
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 4
  }
}

resource "aws_lb_listener" "prod-listener" {
  load_balancer_arn = aws_lb.prod-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-tg.arn
  }
}

resource "aws_lb_listener" "prod-listener2" {
  load_balancer_arn = aws_lb.prod-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "prod-attachmt1" {
  target_group_arn = aws_lb_target_group.prod-tg.arn
  target_id        = var.instance1
  port             = 30002
}

resource "aws_lb_target_group_attachment" "prod-attachmt2" {
  target_group_arn = aws_lb_target_group.prod-tg.arn
  target_id        = var.instance2
  port             = 30002
}

resource "aws_lb_target_group_attachment" "prod-attachmt3" {
  target_group_arn = aws_lb_target_group.prod-tg.arn
  target_id        = var.instance3
  port             = 30002
}

