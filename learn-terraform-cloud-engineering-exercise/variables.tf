variable "base_cidr_block" {
  description = "A /16 CIDR range definition"
  default     = "172.31.0.0/16"
}


variable "availability_zones" {
  description = "A list of availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

