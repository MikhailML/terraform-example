terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
variable "image-id" {
    type = string
}
variable "token" {
    type = string
}
variable "cloud_id" {
    type = string
}
variable "folder_id" {
    type = string
}
variable "zone" {
    type = string
}
provider "yandex" {
  token  =  var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_compute_instance" "kuber-master" {
  name = "kuber-master"
  platform_id = "standard-v1"
  zone = "ru-central1-b"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image-id
    }
  }

  network_interface {
    subnet_id = "e2lt8ds81rrnueciqpq5"
    nat = true
  }

  metadata = {
    foo = "bar"
    ssh-keys = "ubuntu:${file("id_rsa.pub")}"
 }
}

resource "yandex_compute_instance" "kuber-node1" {
  name = "kuber-node1"
  platform_id = "standard-v1"
  zone = "ru-central1-b"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image-id
    }
  }

  network_interface {
    subnet_id = "e2lt8ds81rrnueciqpq5"
    nat = true  
}

  metadata = {
    foo = "bar"
    ssh-keys = "user:${file("id_rsa.pub")}"
 }
}
resource "yandex_vpc_address" "addr" {
  name = "ipAddress"

  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}
