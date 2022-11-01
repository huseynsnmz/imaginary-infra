variable "project_id" {
  type        = string
  description = "Your project ID."
}

variable "access_key" {
  type        = string
  description = "Access Key for project."
}

variable "secret_key" {
  type        = string
  description = "Secret Key for project."
}

variable "ssh_key" {
  type        = string
  description = "SSH key for connecting hosts with ssh key"
}

variable "template_files" {
  type = map(object({
    src  = string
    dest = string
  }))

  default = {
    ansible = {
      src  = "../templates/hosts-ansible.tftpl",
      dest = "hosts.ini"
    }
  }
}
