provider "google" {
  credentials = file(var.service_account_key_file)
  project     = var.project_id
  region      = var.region
}

# Define Artifact Registry repository
resource "google_artifact_registry_repository" "my_repo" {
  repository_id = "my-website-repo"
  format   = "DOCKER"
  location = var.region
  project  = var.project_id
}



# Define Cloud Run service
resource "google_cloud_run_service" "my_service" {
  name     = "my-service"
  location = var.region

  template {
    spec {
      containers {
        image = "${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my_repo.repository_id}/my-website-image:latest" 
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Define Cloud Build trigger
resource "google_cloudbuild_trigger" "my_trigger" {
  name = "my-trigger"

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "main"
    }
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my_repo.repository_id}/my-website-image:latest", "."]
    }
    
    # Push the image
    step {
      name = "gcr.io/cloud-builders/docker" 
      args = ["push", "${google_artifact_registry_repository.my_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my_repo.repository_id}/my-website-image:latest"] 
    } 
    images = ["gcr.io/${var.project_id}/my-website-repo/my-website-image:latest"]

  }

  
    
}

