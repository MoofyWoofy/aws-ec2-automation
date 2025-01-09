# Getting started

```
tofu init
```

## Create variable.tfvars file
```tfvars
aws_api_key = {
  access_key = "AKxxx"
  secret_key = "SECRET_KEY"
}

aws_region     = "ap-southeast-1"
ssh_public_key = "~/.ssh/id_rsa.pub"
hostname       = "ec2"

vm_instance = {
  ami           = "ami-0acbb557db23991cc"
  instance_type = "t2.micro"
  volume_size   = 30
}

# Firewall rules
sg_ingress_rules = {
  "http" = {
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
  },
  "https" = {
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
  }
  "ssh" = {
    cidr_ipv4   = "0.0.0.0/0"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
  }
}

```
## Run code
```sh
tofu validate
tofu apply -var-file="variables.tfvars"
```

