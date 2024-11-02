# main.tf (in ecs-module folder)

# Create a new VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = var.tags
}

# Create subnets
resource "aws_subnet" "subnet" {
  count                  = var.subnet_count
  vpc_id                 = aws_vpc.vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone      = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.task_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = var.task_family
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      memory    = var.container_memory
      cpu       = var.container_cpu
      essential = true
      portMappings = [{
        containerPort = var.container_port
        hostPort      = var.container_port
      }]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.subnet[*].id
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_service_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
