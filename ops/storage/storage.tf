resource "google_storage_bucket" "build" {
  name          = "${var.project_name}-build"
  location      = "EU"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }
}
