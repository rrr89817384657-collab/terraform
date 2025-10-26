terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "ssh://158.160.180.150:22"
}

resource "random_password" "container_name" {
  length  = 8
  special = false
}

resource "random_password" "mysql_root" {
  length  = 16
  special = true
}

resource "random_password" "mysql_user" {
  length  = 16
  special = true
}


resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  name  = "mysql_${random_password.container_name.result}"
  image = docker_image.mysql.name

  ports {
    internal = 3306
    external = 3306
    ip       = "127.0.0.1"
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_user.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}
