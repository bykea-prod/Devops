public_key_path = "~/.ssh/rabbitmq_aws.pub"
region          = "eu-west-2"
ami             = "ami-9fa343e7" 

instance_types = {
  "rabbitmq"  = "t2.micro"
}

num_instances = {
  "rabbitmq"    = 3
}