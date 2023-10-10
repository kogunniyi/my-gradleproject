# create prometheus loadbalancer
resource "aws_lb" "prometheus-lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.prometheus_sg_name]

  tags = {
    Name = "prometheus-lb"
  }
}
resource "aws_lb_target_group" "prometheus-tg" {
  name     = var.name2
  port     = 31090
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
    path                = "/graph"
  }
}

resource "aws_lb_listener" "prometheus-listener1" {
  load_balancer_arn = aws_lb.prometheus-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }
}

resource "aws_lb_listener" "prometheus-listener2" {
  load_balancer_arn = aws_lb.prometheus-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "prometheus-attachment" {
  target_group_arn = aws_lb_target_group.prometheus-tg.arn
  target_id        = element(split(",", join(",", "${var.instance}")), count.index)
  port             = 31090
  count            = 3
}


