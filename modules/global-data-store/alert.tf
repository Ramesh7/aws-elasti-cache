// resource "aws_cloudwatch_metric_alarm" "cloudwatch_replication_lag" {
//   alarm_name          = "Alarm-${var.name}-ElastiCache-Replication-Lag"
//   alarm_description   = "Redis cluster ${var.name} Replication Lag"
//   comparison_operator = "GreaterThanOrEqualToThreshold"
//   evaluation_periods  = "2"
//   metric_name         = "ReplicationLag"
//   namespace           = "AWS/ElastiCache"
//   period              = "120"
//   statistic           = "Average"
//   threshold           = "${var.alarm_replication_lag_threshold}"
//   dimensions = {
//     CacheClusterId    = "${aws_elasticache_replication_group.elasti_cache.id}-001"
//   }
//   alarm_actions       = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
//   ok_actions          = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
// }

// resource "aws_cloudwatch_metric_alarm" "cloudwath_mem_up" {
//   alarm_name          = "Alarm-${var.name}-ElastiCache-Memory-Usage"
//   comparison_operator = "GreaterThanOrEqualToThreshold"
//   evaluation_periods  = "2"
//   metric_name         = "DatabaseMemoryUsagePercentage"
//   namespace           = "AWS/ElastiCache"
//   period              = "120"
//   statistic           = "Average"
//   threshold           = "90"
//   dimensions = {
//     CacheClusterId    = "${aws_elasticache_replication_group.elasti_cache.id}-001"
//   }
//   alarm_description   = "Redis cluster ${var.name} Memory Utilization"
//   alarm_actions       = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
//   ok_actions          = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
// }

// resource "aws_cloudwatch_metric_alarm" "cloudwath_cpu_up" {
//   alarm_name          = "Alarm-${var.name}-ElastiCache-CPU-Usage"
//   comparison_operator = "GreaterThanOrEqualToThreshold"
//   evaluation_periods  = "2"
//   metric_name         = "EngineCPUUtilization"
//   namespace           = "AWS/ElastiCache"
//   period              = "120"
//   statistic           = "Average"
//   threshold           = "90"
//   dimensions = {
//     CacheClusterId    = "${aws_elasticache_replication_group.elasti_cache.id}-001"
//   }
//   alarm_description   = "Redis cluster ${var.name} CPU Utilization"
//   alarm_actions       = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
//   ok_actions          = ["${data.aws_sns_topic.maintenance_sns_topic.arn}"]
// }
