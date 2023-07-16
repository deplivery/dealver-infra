output "load_balancer_ip" {
  value = aws_lb.alb.dns_name
}

output "repository-URL" {
  value = aws_ecr_repository.repository.repository_url
}
