variable "aws_region" {
  default     = "eu-central-1"
  description = "aws region"
}

variable "env" {
  default     = "dev"
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "vpc" {
  default     = "vpc"
  description = "Name of the vpc"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}

#variable "vpc_subnet


variable "kubernetes_version" {
  default     = "1.31"
  description = "kubernetes version"
}
