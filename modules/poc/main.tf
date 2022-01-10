data "aws_subnet" "primary_subnets" {
    for_each = var.cluster_config

    // count   = length(each.value.availability_zones)

    tags    = {
      Name = "${each.value.vpc_name}-private-${element(each.value.availability_zones, length(each.value.availability_zones).index)}"
    }
}
