resource "google_project_service" "resources" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}
