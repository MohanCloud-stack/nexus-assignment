variable "vpc_name" {
  description = "nexus-eks-cluster"
  default = "nexus-eks-cluster"
}
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}
variable "cluster_name" {
  default = "nexus-eks-cluster"
}

variable "desired_size" {
  description = "Desired size of the worker node, the default value is 2"
  default     = 2
}

variable "max_size" {
  default     = 2
}
variable "min_size" {
  default     = 1
}
variable "instance_types" {
  default     = ["t3.medium"]

}
variable "cluster_id" {
  description = "Name of the EKS cluster where the ingress nginx will be deployed"
  default="nexus-eks-cluster"

}