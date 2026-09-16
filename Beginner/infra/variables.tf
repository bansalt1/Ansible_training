variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-02cada047ebd954cf"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "vm_count" {
  description = "Total number of VMs (1 control node + remaining managed nodes)"
  type        = number
  default     = 4
}
