variable "aws_api_key" {
  description = "AWS access & secret key"
  type = object({
    access_key = string
    secret_key = string
  })
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "ssh_key_pair" {
  description = "SSH key pair location"
  type = object({
    public  = string
    private = string
  })
}

variable "vm_instance" {
  description = "VM configurations"
  type = object({
    ami           = string
    instance_type = string
    volume_size   = number
  })
  default = {
    ami           = "ami-0acbb557db23991cc" # Debian 12
    instance_type = "t2-micro"
    volume_size   = 30
  }
}

variable "sg_ingress_rules" {
  description = "Rules to be added to the security group"
  type = map(object({
    cidr_ipv4   = string
    ip_protocol = string
    from_port   = number
    to_port     = number
  }))
}

variable "hostname" {
  description = "Hostname for vps"
  type        = string
}
