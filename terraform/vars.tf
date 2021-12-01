variable "AWS_ACCESS_KEY" {
  type        = string
  default     = ""
  description = "The access key"
}

variable "AWS_SECRET_KEY" {
  type        = string
  default     = ""
  description = "The secret key"
}

variable "AWS_REGION" {
  type        = string
  default     = "us-east-1"
  description = "The region"
}

variable "AWS_AZ" {
  type        = string
  default     = "us-east-1a"
  description = "description"
}

variable "AWS_CIDR" {
  type        = map(string)
  default     = {
      "vpc"             = "10.0.0.0/16"
      "subnet_public"   = "10.0.0.0/24"
      "subnet_private"  = "10.0.1.0/24"
  }
  description = "description"
}
