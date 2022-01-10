# Local function to evaluate cluster mode enable/disable params
locals {
  my_function_name = "awesome-function"
}

data "aws_subnet" "subnets" {
    count  = length(var.availability_zones)

    tags = {
      Name = "${var.vpc_name}-private-${element(var.availability_zones, count.index)}"
    }
}

data "aws_security_group" "security_groups" {
    count = length(var.security_groups)
    name  = "${var.vpc_name}-${element(var.security_groups, count.index)}"
}

data "aws_sns_topic" "maintenance_sns_topic" {
    name = var.maintenance_sns_topic
}

resource "aws_elasticache_subnet_group" "cache_subnet_group" {
    name       = var.name
    subnet_ids = flatten([data.aws_subnet.subnets.*.id])
}

resource "aws_elasticache_parameter_group" "cache_parameter_group" {
    name = var.name
    family = var.parameter_group_name

    parameter {
      name = "maxmemory-policy"
      value = var.maxmemory_policy
    }

    parameter {
      name  = "cluster-enabled"
      value = var.cluster_mode ? "yes" : "no"
    }
}

resource "aws_elasticache_replication_group" "elasti_cache" {
    replication_group_id          = var.name
    replication_group_description = "Managed by Terraform"
    automatic_failover_enabled    = true
    
    dynamic "cluster_mode" {
      for_each = var.cluster_mode ? ["true"] : []

      content {
        replicas_per_node_group   = var.replica_count
        num_node_groups           = var.shards_count
      }
    }
    number_cache_clusters         = var.cluster_mode ? null : var.replica_count
    engine                        = "redis"
    engine_version                = var.engine_version
    at_rest_encryption_enabled    = true
    transit_encryption_enabled    = true
    node_type                     = var.node_type
    auth_token                    = var.auth_token != "" ? var.auth_token : null
    subnet_group_name             = aws_elasticache_subnet_group.cache_subnet_group.name
    security_group_ids            = flatten([data.aws_security_group.security_groups.*.id])
    parameter_group_name          = aws_elasticache_parameter_group.cache_parameter_group.name
    notification_topic_arn        = data.aws_sns_topic.maintenance_sns_topic.arn
    apply_immediately             = var.apply_immediately
    data_tiering_enabled          = try(length(regex("^cache.r6gd.", var.node_type)) > 0, false)
    multi_az_enabled              = true

    lifecycle {
      ignore_changes = ["auth_token"]
    }

    tags = {
      Name = var.name
    }
}
