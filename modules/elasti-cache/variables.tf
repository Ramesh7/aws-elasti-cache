variable "name" {
    type    = string
    default = ""
}

variable "vpc_name" {
    type    = string
    default = ""
}

variable "availability_zones" {
    description   = "List of AWS cache zomes"
    type          = list
    default       = ["a", "b", "c"]
}

variable "shards_count" {
    type    = number
    default = 2
}

variable "apply_immediately" {
    type    = bool
    default = false
}

variable "security_groups" {
    description = "Name of security Group"
    type        = list
    default     =  [ "redissg-v2" ]
}

variable "maintenance_sns_topic" {
    type    = string
    default = "coupa_victorops_sre"
}

variable "parameter_group_name" {
    type      = string
    default   = "redis6.x"
}

variable "maxmemory_policy" {
    type    = string
    default = "volatile-lru"
}

variable "cluster_mode" {
    type    = bool
    default = false
}

variable "replica_count" {
    type    = number
    default = 2
}

variable "engine_version" { 
    type    = string
    default = "6.x"
}

variable "node_type" {
    type    = string
    default = "cache.r6gd.xlarge"
}

variable "alarm_replication_lag_threshold" {
    type    = string
    default = ""
}

variable "multi_az_enabled" {
    type    = bool
    default = true
}

variable "data_tiering_enabled" {
    type    = bool
    default = false
}

variable "auth_token" {
    type    = string
    default = ""
}
