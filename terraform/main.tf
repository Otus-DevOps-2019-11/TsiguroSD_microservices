terraform {
  # Версия terraform
  required_version = "~> 0.12.0"
}

provider "google" {
  # Версия провайдера
  version = "~> 2.5"
  # ID проекта
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "gitlab-ci" {
  name ="gitlab-ci"
  machine_type = "custom-1-3840"
  zone = var.zone
  tags = ["gitlab"]
  boot_disk {
    initialize_params { image = var.disk_image }
 }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }
  allow_stopping_for_update = true
}

resource "google_compute_firewall" "firewall_gitlab_http" {
  name = "allow-gitlab-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gitlab"]
}

resource "google_compute_firewall" "firewall_gitlab_https" {
  name = "allow-gitlab-https"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gitlab"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges =  ["0.0.0.0/0"]

}
