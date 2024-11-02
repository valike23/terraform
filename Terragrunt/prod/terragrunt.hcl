terraform {
  source = "../../ecs-module"
}

inputs = {
  vpc_cidr_block         = "10.0.0.0/16"
  subnet_count           = 2
  cluster_name           = "prod-ecs-cluster"
  task_execution_role_name = "prod-ecs-task-execution-role"
  task_family            = "prod-task-family"
  container_name         = "my-container"
  container_image        = "nginx"
  container_memory       = 512
  container_cpu          = 256
  container_port         = 80
  service_name           = "prod-ecs-service"
  desired_count          = 1
  tags                   = { "Environment" = "prod" }
}
