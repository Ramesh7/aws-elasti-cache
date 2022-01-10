variable "name" {
  type  = string
}

variable "cluster_config" {
    type    = map(any)
    default = {
        primary = {
            vpc_name              = "",
            availability_zones    = []
            region                = "",
            shards_count          = 1,
            replica_count         = 1,
            security_groups       = []
        },
        secondary = {
            vpc_name              = "",
            availability_zones    = [],
            region                = "",
            shards_count          = 1,
            replica_count         = 1,
            security_groups       = []
        }
    }
}
