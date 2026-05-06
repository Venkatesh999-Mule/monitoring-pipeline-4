output "aws_instance_public_ip" {
    value = "${aws_instance.Monitoring_instance-4.public_ip}"
}
output "jenkins" {
    value = "http://${aws_instance.Monitoring_instance-4.public_ip}:8080" 
}
output "Prometheus" {
    value = "http://${aws_instance.Monitoring_instance-4.public_ip}:9090" 
}
output "grafana" {
    value = "http://${aws_instance.Monitoring_instance-4.public_ip}:3000" 
}