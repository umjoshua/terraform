#AWS Key Pair
resource "aws_key_pair" "levelup-key-pair" {
  key_name   = "levelup-key-pair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}


# Launch Configuration
resource "aws_launch_configuration" "levelup-launch-configuration" {
  name_prefix     = "levelup-lc"
  image_id        = var.AMI
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.levelup-instance-sg.id]
  key_name        = aws_key_pair.levelup-key-pair.key_name
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true
  }
}

#Auto scaling group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier       = [aws_subnet.levelup-vpc-public-subnet-1.id, aws_subnet.levelup-vpc-public-subnet-2.id]
  max_size                  = 2
  min_size                  = 2
  launch_configuration      = aws_launch_configuration.levelup-launch-configuration.name
  health_check_grace_period = 200
  health_check_type         = "EC2"
  load_balancers            = [aws_elb.levelup-elb.name]
  force_delete              = true
}

resource "aws_autoscaling_policy" "levelup-autoscale-policy" {
  name                   = "levelup-autoscale-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
}


resource "aws_cloudwatch_metric_alarm" "levelup-autoscale-alarm" {
  alarm_name          = "levelup-autoscale-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30

  actions_enabled = true

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.levelup-autoscaling.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.levelup-autoscale-policy.arn]
}

resource "aws_autoscaling_policy" "levelup-scale-down-policy" {
  name                   = "levelup-scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
}

resource "aws_cloudwatch_metric_alarm" "levelup-autoscale-down-alarm" {
  alarm_name          = "levelup-autoscale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 10

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.levelup-autoscale-policy.arn]
}
