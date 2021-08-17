# Input variable definitions

variable "bucket_name" {
  description = "george-example-08-16-2021"
  type        = string
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}
