variable "project" {
    default = "roboshop"
  
}

variable "environment" {
    default = "dev"
}

variable "frontend_sg_name" {
    default = "frontend"
}

variable "frontend_sg_name_description" {
    default = "Created EC2 instance"
    type = string
}

variable "sg_tags" {
    type = map(string)
    default = {}
}

variable "bastion_sg_name" {
    default = "bastion"
}

variable "bastion_sg_description" {
    default = "Created EC2 instance for bastion host"
}
variable "mongodb_vpn_ports" {
  default = [22,27017]
}

variable "redis_vpn_ports" {
  default = [22,6379]
}

variable "mysql_vpn_ports" {
    default = [22,3306]
  
}

variable "rabbitmq_vpn_ports" {
  default = [22,5672]
}