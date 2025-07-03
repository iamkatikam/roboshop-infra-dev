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
    default = "frontend"
}

variable "bastion_sg_description" {
    default = "Created EC2 instance"
    type = string
}