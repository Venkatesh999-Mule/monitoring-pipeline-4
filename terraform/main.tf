provider "aws" {
    region = var.region
}
resource "aws_security_group" "Monitoring-pipeline-SG" {
    name = "Monitoring_SG"
    description = "ports for my pipeline for monitoring"

    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "jenkins"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "prometheus"
        from_port = 9090
        to_port = 9090
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "grafana"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Node_exporter"
        from_port = 9100
        to_port = 9100
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "outside traffice"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_instance" "Monitoring_instance-4" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.Monitoring-pipeline-SG.id]
    user_data = <<-EOF
${file("${path.module}/../scripts/All_packages.sh")}
${file("${path.module}/../scripts/progra_install.sh")}
EOF
    key_name = "Devops-project-1"

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
    }
tags = {
  Name = "Monitoring_pipeline_instance-4"
}

}