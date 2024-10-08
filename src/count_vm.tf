resource "yandex_compute_instance" "web" {
  count = var.count_web_vm
  depends_on = [yandex_compute_instance.db]

  name = "web-${count.index + 1}"

  resources {
    cores  = var.vm_web_resources.cores
    memory = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_params.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  scheduling_policy {
    preemptible = var.vm_web_params.preemptible
  }

  metadata = local.vm_metadata
}
