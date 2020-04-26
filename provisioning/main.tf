provider "google" {
  version = "3.5.0"

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip"
}

resource "google_compute_firewall" "http-8080" {
  name = "http-8080"
  network = "terraform-network"

  allow {
    protocol = "tcp"
    ports = ["8080"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh-22"
  network = "terraform-network"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

module "gce-container" {
  source = "github.com/terraform-google-modules/terraform-google-container-vm"

  cos_image_name = "cos-stable-77-12371-89-0"

  container = {
    image = "gcr.io/aizuchi/aizuchi"
    command = "docker run -p 8080:8080 gcr.io/aizuchi/aizuchi"
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "vm_instance" {
  name         = "aizuchi-instance"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  metadata = {
    gce-container-declaration = "spec:\n  containers:\n    - name: test-docker\n      image: 'gcr.io/aizuchi/aizuchi'\n      stdin: true\n      tty: false\n  restartPolicy: Always\n"
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }


  service_account {
    email = var.service_account_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

