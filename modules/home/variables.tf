variable "main_domain" {
  type = string
}

variable "others_domain" {
  type    = list(string)
  default = []
}