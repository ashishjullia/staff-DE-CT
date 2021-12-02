terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = var.ARM_SUBSCRIPTION_ID
  tenant_id         = var.ARM_TENANT_ID
  client_id         = var.ARM_CLIENT_ID
  client_secret     = var.ARM_CLIENT_SECRET
}

resource "azurerm_resource_group" "k8s" {
  name = "myaksResourceGroupde"
  location = "eastus"
}

# Your code goes here



resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "ubuntu"

        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2as_v4"
    }

    service_principal {
        client_id     = var.ARM_CLIENT_ID
        client_secret = var.ARM_CLIENT_SECRET
    }

    addon_profile {
        oms_agent {
        enabled                    = false
        }
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "Terraform Demo for Canadian Tire"
    }
}