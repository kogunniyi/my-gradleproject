#Create Jenkins Server using a t2.medium redhat ami 
resource "aws_instance" "jenkins-server" {
  ami                    = var.ami-redhat
  instance_type          = var.instance_type_t2
  vpc_security_group_ids = [var.jenkins_sg]
  subnet_id              = var.prt_sn1
  key_name               = var.keypair_name
  user_data              = local.jenkins-userdata
  tags = {
    Name = var.jenkins_name
  }
}


# create jenkins load balancer

resource "aws_elb" "jenkins_lb" {
  name            = var.jenkins_name
  subnets         = var.subnet_id2
  security_groups = [var.jenkins_sg]
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }
  instances                   = [aws_instance.jenkins-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = var.jenkins_name
  }
}