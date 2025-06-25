provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "governance-test" {
  bucket = "governance-test"
}

resource "aws_s3_bucket_public_access_block" "governance-test-public-access-block" {
  bucket = aws_s3_bucket.governance-test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# 2 Simple Low Resolution Alarms (60s)
resource "aws_cloudwatch_metric_alarm" "low_res_1" {
  alarm_name          = "low-res-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "Low resolution CPU alarm"
}

resource "aws_cloudwatch_metric_alarm" "low_res_2" {
  alarm_name          = "low-res-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "MemoryUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 75
  alarm_description  = "Low resolution memory alarm"
}

# 2 Simple High Resolution Alarms (10s)
resource "aws_cloudwatch_metric_alarm" "high_res_1" {
  alarm_name          = "high-res-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 10
  statistic          = "Average"
  threshold          = 80
  alarm_description  = "High resolution CPU alarm"
}

resource "aws_cloudwatch_metric_alarm" "high_res_2" {
  alarm_name          = "high-res-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "MemoryUtilization"
  namespace          = "AWS/EC2"
  period             = 10
  statistic          = "Average"
  threshold          = 75
  alarm_description  = "High resolution memory alarm"
}

# Complex Alarm 1 with Multiple Metric Queries
resource "aws_cloudwatch_metric_alarm" "complex_alarm_1" {
  alarm_name          = "complex-alarm-1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 90
  alarm_description   = "Complex alarm with multiple metrics"

  # Low Resolution Metric Queries
  metric_query {
    id          = "low1"
    return_data = false
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      period     = 60
      stat       = "Average"
    }
  }

  metric_query {
    id          = "low2"
    return_data = false
    metric {
      metric_name = "MemoryUtilization"
      namespace   = "AWS/EC2"
      period     = 60
      stat       = "Average"
    }
  }

  # High Resolution Metric Queries
  metric_query {
    id          = "high1"
    return_data = false
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      period     = 10
      stat       = "Average"
    }
  }

  metric_query {
    id          = "high2"
    return_data = false
    metric {
      metric_name = "MemoryUtilization"
      namespace   = "AWS/EC2"
      period     = 10
      stat       = "Average"
    }
  }

  # Metrics Insights Queries
  metric_query {
    id          = "mi1"
    return_data = false
    expression  = "SELECT AVG(CPUUtilization) FROM AWS/EC2 GROUP BY InstanceId"
  }

  metric_query {
    id          = "mi2"
    return_data = true
    expression  = "SELECT AVG(MemoryUtilization) FROM AWS/EC2 GROUP BY AutoScalingGroupName"
  }
}

# Complex Alarm 2 with Multiple Metric Queries
resource "aws_cloudwatch_metric_alarm" "complex_alarm_2_test" {
  alarm_name          = "complex-alarm-2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 90
  alarm_description   = "Complex alarm with multiple metrics"

  # Low Resolution Metric Queries
  metric_query {
    id          = "low1"
    return_data = false
	period = 10
    metric {
      metric_name = "NetworkIn"
      namespace   = "AWS/EC2"
      period     = 60
      stat       = "Average"
    }
  }

  metric_query {
    id          = "low2"
    return_data = false
    metric {
      metric_name = "NetworkOut"
      namespace   = "AWS/EC2"
      period     = 60
      stat       = "Average"
    }
  }

  # High Resolution Metric Queries
  metric_query {
    id          = "high1"
    return_data = false
    metric {
      metric_name = "NetworkIn"
      namespace   = "AWS/EC2"
      period     = 10
      stat       = "Average"
    }
  }

  metric_query {
    id          = "high2"
    return_data = false
    metric {
      metric_name = "NetworkOut"
      namespace   = "AWS/EC2"
      period     = 10
      stat       = "Average"
    }
  }

  # Metrics Insights Queries
  metric_query {
    id          = "mi1"
    return_data = false
    expression  = "SELECT SUM(NetworkIn) FROM AWS/EC2 GROUP BY InstanceId"
  }

  metric_query {
    id          = "mi2"
    return_data = true
    expression  = "SELECT SUM(NetworkOut) FROM AWS/EC2 GROUP BY InstanceId"
  }
}
