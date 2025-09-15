terraform {
  backend "remote" {
    organization = "badclick-org"

    workspaces {
      name = "cloud-k8s-security-bootstrapped"
    }
  }
}