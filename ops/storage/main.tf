terraform {
  required_version = "1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.59.0"
    }
  }
  backend "gcs" {}
}

# cloud provider info :  #  project id , credentials , region , zone info are configured through environment variables
provider "google" {}

# enables access to the attributes (e.g project)
data "google_client_config" "default" {}
