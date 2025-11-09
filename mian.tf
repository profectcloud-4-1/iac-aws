terraform {
    cloud {
      organization = "goormdotcom"
      hostname = "app.terraform.io"
      workspaces {
        name = "prod"
      }
    }
}