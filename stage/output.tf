output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The vpc id created"
}

output "ec2_instance_ip" {
  value = module.ec2_instance.ec2_ip
  description = "The public ip of the ec2 instance"
}

output "db_endpoint" {
  value = module.db.db_endpoint
  description = "The endpoint of the db"
}

output "redis_endpoint" {
  value = module.redis.redis_cluster_info
  description = "The endpoint of redis"
}

output "bootstrap" {
  value = module.msk.bootstrap
}

output "zookeeper" {
  value = module.msk.zookeeper
}