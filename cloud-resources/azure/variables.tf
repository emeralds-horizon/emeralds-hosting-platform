variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group to use."
  default     = "EMERALDS_res_group" # Optional: provide a default value
}

variable "username" {
    type = string
    description = "The username for the VM admin."
    default = "emerlads_admin" 
}

variable "vm_names" {
  default = ["vm1"]
}