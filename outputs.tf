output "project_id" {
  description = "Project hosting the foundation."
  value       = var.project_id
}

output "vpc_names" {
  description = "Separate VPCs for dev and prod."
  value       = { for name, vpc in module.environment_vpc : name => vpc.name }
}

output "subnet_ids" {
  description = "Subnets created by the Fabric module."
  value       = { for name, vpc in module.environment_vpc : name => vpc.subnet_ids }
}

