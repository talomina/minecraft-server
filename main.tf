provider "google" {
}
# [START vpc]
resource "google_compute_network" "vpc_network" {
  name                    = "my-minecraft-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}
# [END vpc]
# [START subnet]
resource "google_compute_subnetwork" "default" {
  name          = "my-minecraft-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-northeast1"
  network       = google_compute_network.vpc_network.id
}
# [END subnet]
# [START instance]
resource "google_compute_instance" "default" {
  name         = "minecraft-vm"
  machine_type = "e2-medium"
  zone         = "asia-northeast1-a"
  tags         = ["ssh","minecraft-fw"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  # Install minecraft
  # metadata_startup_script = "sudo apt-get update; sudo apt-get install -y default-jre-headless; sudo apt-get install wget; sudo apt-get install -y screen"
  metadata_startup_script = file("./init.sh") 

  network_interface {
    subnetwork = google_compute_subnetwork.default.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}
# [END instance]
# [START ssh_fw]
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
# [END ssh_fw]
# [START minecraft_fw]
resource "google_compute_firewall" "minecraft_fw" {
  name    = "minecraft-firewall"
  network = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  priority      = 1000

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-fw"]
}
# [END minecraft_fw]
