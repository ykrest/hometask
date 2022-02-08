variable "region" {
  description = "Region to be used"
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3.micro"
}

variable "allowed_ports" {
  description = "List of open ports for the server"
  default     = ["80", "22"]
}

variable "ami_linux_recent" {
  description = "Select to use latest image of Linux"
  default     = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(any)
  default = {
    Owner   = "Yuri Krestyansky"
    Project = "Carbyne911"
  }
}
