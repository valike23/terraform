variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of subnets to create"
  default     = 2
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  default     = "my-ecs-cluster"
}

variable "task_execution_role_name" {
  description = "IAM Role name for ECS Task Execution"
  default     = "ecsTaskExecutionRole"
}

variable "task_family" {
  description = "Task definition family"
  default     = "my-task-family"
}

variable "container_name" {
  description = "Container name"
  default     = "my-container"
}

variable "container_image" {
  description = "Docker image to use for ECS task"
}

variable "container_memory" {
  description = "Memory for the container"
  default     = 512
}

variable "container_cpu" {
  description = "CPU units for the container"
  default     = 256
}

variable "container_port" {
  description = "Port the container listens on"
}

variable "service_name" {
  description = "Name of the ECS service"
  default     = "my-ecs-service"
}

variable "desired_count" {
  description = "Desired number of ECS service instances"
  default     = 1
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
