
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "k8s-platform-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "West US"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "multi-cloud-k8s"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "node_size" {
  description = "VM size for the nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.11"
}