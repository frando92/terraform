	terraform {
	  required_providers {
	    docker = {
	      source  = "kreuzwerker/docker"
	      version = "~> 3.0"
	    }
	    null = {
	      source  = "hashicorp/null"
	      version = "~> 3.0"
	    }
	  }
	}
	
	resource "null_resource" "install_docker" {
	  provisioner "local-exec" {
	    command = <<-EOT
	      if ! command -v docker &> /dev/null; then
	        curl -fsSL https://get.docker.com -o get-docker.sh
	        sudo sh get-docker.sh
	        sudo usermod -aG docker $USER
	        sudo systemctl enable docker
	        sudo systemctl start docker
	        rm get-docker.sh
	      fi
	    EOT
	  }
	}
	
	provider "docker" {
	  host = "unix:///var/run/docker.sock"
	}
	
	resource "docker_image" "nginx" {
	  name = "nginx:latest"
	  depends_on = [null_resource.install_docker]
	}
	resource "docker_container" "nginx" {
	  image = docker_image.nginx.image_id
	  name  = "enginecks"
	  ports {
	    internal = 80
	    external = 80
	  }
	  depends_on = [null_resource.install_docker]
	}
	
	resource "docker_image" "apache" {
	  name = "httpd:latest"
	  depends_on = [null_resource.install_docker]
	}
	
	resource "docker_container" "apache" {
	  image = docker_image.apache.image_id
	  name  = "apache-web"
	  ports {
	    internal = 80
	    external = 8080
	  }
	  depends_on = [null_resource.install_docker]
	}

