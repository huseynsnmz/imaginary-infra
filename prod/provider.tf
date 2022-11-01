provider "scaleway" {
  project_id = var.project_id
  access_key = var.access_key
  secret_key = var.secret_key
  zone       = "nl-ams-2"
  region     = "nl-ams"
}

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
}
