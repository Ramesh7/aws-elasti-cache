provider "aws" {
    region = "us-east-1"
}

// provider "aws" {
//     alias   = "other_region"
//     region  = "us-west-1"
// }

module "elasti_cache" {
    source                  = "./modules/elasti-cache"
    name                    = "data-tiering-poc-3"
    cluster_mode            = true
    node_type               = "cache.r6g.xlarge"
    vpc_name                = "devvpc2"
    alarm_replication_lag_threshold = 70
}
