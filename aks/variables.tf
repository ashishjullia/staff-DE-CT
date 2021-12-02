variable "ARM_SUBSCRIPTION_ID" {
  description = "ARM_SUBSCRIPTION_ID"
  type        = string
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  description = "ARM_TENANT_ID"
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_ID" {
  description = "ARM_CLIENT_ID"
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  description = "ARM_CLIENT_SECRET"
  type        = string
  sensitive   = true
}


# Number of nodes in the node pool "agentpool"
variable "agent_count" {
    default = 1
}

variable "ssh_public_key" {
    default = "./id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8stest"
}

variable cluster_name {
    default = "k8stest"
}
