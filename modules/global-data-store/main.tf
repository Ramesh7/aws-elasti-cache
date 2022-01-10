provider "aws" {
    alias   = "secondary_region"
    region  = var.secondary_region
}


// Primary cluster subnet config
data "aws_subnet" "primary_subnets" {
    count   = length(var.availability_zones)

    tags    = {
      Name = "${var.primary_vpc_name}-private-${element(var.availability_zones, count.index)}"
    }
}

data "aws_security_group" "primary_security_groups" {
    count = length(var.security_groups)
    name  = "${var.primary_vpc_name}-${element(var.security_groups, count.index)}"
}

resource "aws_elasticache_subnet_group" "primary_cache_subnet_group" {
    name       = var.name
    subnet_ids = flatten([data.aws_subnet.primary_subnets.*.id])
}

resource "aws_elasticache_parameter_group" "primary_cache_parameter_group" {
    name    = var.name
    family  = var.parameter_group_name

    parameter {
      name  = "maxmemory-policy"
      value = var.maxmemory_policy
    }

    parameter {
      name  = "cluster-enabled"
      value = var.cluster_mode ? "yes" : "no"
    }
}

data "aws_sns_topic" "primary_maintenance_sns_topic" {
    name = var.maintenance_sns_topic
}

// secondary cluster config
data "aws_subnet" "secondary_subnets" {
    provider  = aws.secondary_region
    count     = length(var.availability_zones)

    tags = {
      Name = "${var.secondary_vpc_name}-private-${element(var.availability_zones, count.index)}"
    }
}

resource "aws_elasticache_subnet_group" "secondary_cache_subnet_group" {
    provider  = aws.secondary_region
    name       = var.name
    subnet_ids = flatten([data.aws_subnet.secondary_subnets.*.id])
}

data "aws_security_group" "secondary_security_groups" {
    provider  = aws.secondary_region
    count     = length(var.security_groups)
    name      = "${var.secondary_vpc_name}-${element(var.security_groups, count.index)}"
}

resource "aws_elasticache_parameter_group" "secondary_cache_parameter_group" {
    provider = aws.secondary_region
    name    = var.name
    family  = var.parameter_group_name

    parameter {
      name  = "maxmemory-policy"
      value = var.maxmemory_policy
    }

    parameter {
      name  = "cluster-enabled"
      value = var.cluster_mode ? "yes" : "no"
    }
}

data "aws_sns_topic" "secondary_maintenance_sns_topic" {
    provider  = aws.secondary_region
    name = var.maintenance_sns_topic
}

// actual cluster config

resource "aws_elasticache_global_replication_group" "globaldatastore" {
  global_replication_group_id_suffix = var.name
  primary_replication_group_id       = aws_elasticache_replication_group.primary_elasti_cache.id
}

resource "aws_elasticache_replication_group" "primary_elasti_cache" {
    replication_group_id          = var.name
    replication_group_description = "Managed by Terraform"
    automatic_failover_enabled    = true
    
    dynamic "cluster_mode" {
      for_each = var.cluster_mode ? ["cluster-mode-eanbled"] : []

      content {
        replicas_per_node_group     = var.replica_count
        num_node_groups             = var.shards_count
      }
    }
    
    number_cache_clusters         = var.cluster_mode ? null : var.replica_count
    engine                        = "redis"
    engine_version                = var.engine_version
    at_rest_encryption_enabled    = true
    transit_encryption_enabled    = true
    node_type                     = var.node_type
    subnet_group_name             = aws_elasticache_subnet_group.primary_cache_subnet_group.name
    security_group_ids            = flatten([data.aws_security_group.primary_security_groups.*.id])
    parameter_group_name          = aws_elasticache_parameter_group.primary_cache_parameter_group.name
    notification_topic_arn        = data.aws_sns_topic.primary_maintenance_sns_topic.arn
    apply_immediately             = var.apply_immediately
    data_tiering_enabled          = try(length(regex("^cache.r6gd.", var.node_type)) > 0, false)
    multi_az_enabled              = true

    tags = {
      Name = var.name
    }
}

resource "aws_elasticache_replication_group" "secondary_elasti_cache" {
    provider                      = aws.secondary_region
    replication_group_id          = var.name
    global_replication_group_id   = aws_elasticache_global_replication_group.globaldatastore.global_replication_group_id
    replication_group_description = "Managed by Terraform"
    subnet_group_name             = aws_elasticache_subnet_group.secondary_cache_subnet_group.name
    security_group_ids            = flatten([data.aws_security_group.secondary_security_groups.*.id])
    automatic_failover_enabled    = true
    
    cluster_mode {
        replicas_per_node_group     = var.secondary_replica_count
    }
    
    notification_topic_arn        = data.aws_sns_topic.secondary_maintenance_sns_topic.arn
    apply_immediately             = var.apply_immediately
    multi_az_enabled              = true

    tags = {
      Name = var.name
    }
}
