variable "myregion" {
    default = "us-east-1"
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    tags = map(string)
  }))
  default = {
    private1 = {
      cidr_block = "10.0.1.0/24"
      tags       = {
        Name = "Private_VPC_1"
      }
    }
    private2 = {
      cidr_block = "10.0.2.0/24"
      tags       = {
        Name = "Private_VPC_2"
      }
    }
    public1 = {
      cidr_block = "10.0.3.0/24"
      tags       = {
        Name = "Public_VPC_1"
      }
    }
    public2 = {
      cidr_block = "10.0.4.0/24"
      tags       = {
        Name = "Public_VPC_2"
      }
    }
  }
}