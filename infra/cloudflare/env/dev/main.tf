terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {
  # get from env var CLOUDFLARE_API_TOKEN
}

variable "zone_id" {
  default = "45ca258d52f527a47a5e239f30168d3d"
}

# variable "account_id" {
#   default = "<YOUR_ACCOUNT_ID>"
# }

variable "domain" {
  default = "harripersad.org"
}

resource "cloudflare_ruleset" "custom" {
  zone_id = "45ca258d52f527a47a5e239f30168d3d"
  name    = "default"                      # keep as-is to avoid replacement
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    # 1) Country block RU
    {
      action      = "block"
      description = "Block RU (test)"
      expression  = "(ip.geoip.country eq \"RU\")"
      enabled     = true
    },

    # 2) User-Agent block (easy to test with curl)
    {
      action      = "block"
      description = "Block User-Agent curl"
      expression  = "(http.user_agent contains \"curl\")"
      enabled     = true
    },

    # 3) Path prefix block
    {
      action      = "block"
      description = "Block /admin path prefix"
      expression  = "(http.request.uri.path contains \"/admin\")"
      enabled     = true
    },

    # 4) “Script” content-type block (requests sending JS payloads)
    {
      action      = "block"
      description = "Block requests with script content-type"
      expression  = "(http.request.uri.query contains \"<script>\")"
      enabled     = true
    }
  ]
}