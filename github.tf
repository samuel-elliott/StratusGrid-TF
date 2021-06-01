resource "github_repository" "StratusGrid" {
  name         = "StratusGrid"
  description  = "StratusGrid"
  homepage_url = "https://github.com/samuel-elliott/StratusGrid"

  # Getting warning about this despite it being in official Terraform documentation example.
  # FILE BUG REPORT TO GET DOCUMENTATION UPDATED!
#  private = false
  visibility = "public"
}
