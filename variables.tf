variable "name" {
    type = string
    default = "test-module"
}

variable "vpc_name" {
    type = string
    default = "devvpc2"
}

variable "cache_zones" {
  description   = "List of AWS cache zomes"
  type          = list
  default       = ["a", "b", "c"]
}

variable "cache_sgs" {
    description = "Name of security Group"
    type        = list
    default     =  [ "redissg-v2" ]
}

variable "cache_parameter_group_name" {
  type      = string
  default   = "default.redis6.x"
}

variable "maxmemory_policy" {
    type    = string
    default = "volatile-lru"
}

variable "cluster_mode" {
    type    = bool
    default = false
}

variable "cache_replicas" {
    type = number
    default = 1
}

variable "cache_engine_version" { 
    type = string
    default = "redis6.x"
}

variable "cache_instance_class" {
    type    = string
    default = ""
}

variable "alarm_replication_lag_threshold" {
    type = string
    default = ""
}
