region            = "eu-west-1"
availability_zone = "eu-west-1b"
private_key_file  = "benchmark_message_aws.pem"
key_name          = "available-key.pem"
image_id          = ""

instance_types = {
  "rabbitmq"    = "t2.micro"
}

num_instances = {
  "rabbitmq"    = 3
}
