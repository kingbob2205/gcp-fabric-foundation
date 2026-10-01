# The FAST landing-zone toolkit operates at organization scope. This intentionally
# smaller project-level foundation uses a pinned Cloud Foundation Fabric module.
resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

module "environment_vpc" {
  for_each = var.environments

  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v59.0.0"

  project_id = var.project_id
  name       = "${var.name_prefix}-${each.key}"

  subnets = [
    {
      name                  = "${var.name_prefix}-${each.key}-${var.region}"
      region                = var.region
      ip_cidr_range         = each.value.subnet_cidr
      enable_private_access = true
      secondary_ip_ranges = {
        pods     = { ip_cidr_range = each.value.pods_cidr }
        services = { ip_cidr_range = each.value.services_cidr }
      }
    }
  ]

  depends_on = [google_project_service.compute]
}

# Only VMs explicitly tagged for administration would accept IAP SSH.
# There are no VMs in this repository and no ingress rule from the Internet.
resource "google_compute_firewall" "iap_ssh" {
  for_each = module.environment_vpc

  project       = var.project_id
  name          = "${var.name_prefix}-${each.key}-iap-ssh"
  network       = each.value.name
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

