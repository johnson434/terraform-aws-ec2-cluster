output "id" {
  value = aws_vpc.total_service.id
}

output "name" {
  value = aws_vpc.total_service.tags["Name"]
}
