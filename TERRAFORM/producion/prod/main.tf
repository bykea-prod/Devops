module "production-test" {
source = "../"

environment_tag = "production-env"

cidr_vpc    = "10.3.0.0/16"



vpc_name = "production-test-vpc"


public_cidr_subnet = "10.3.0.0/24"

availability_zone = "us-east-1a"

subnet_name = "public-subnet-1"

public_cidr_subnet_3 = "10.3.1.0/24"


availability_zone_3 = "us-east-1c"

 
subnet_name_1 = "public_subnet_2"

igw_name = "public_subnet_igw"

pubsubnet_rt_name = "public_rt"


private_cidr_subnet = "10.3.2.0/24"

availability_zone_1 = "us-east-1b"

prisubnet_name = "private_subnet_1"


private_cidr_subnet_1 = "10.3.3.0/24"

prisubnet_name_1 = "public_subnet_2"

private_rt_name_1 = "private_rt_name"

webserver_port = "0"

webserver_port_1 = "443"

webserver_port_2 = "80"

webserver_port_3 = "3000" 


instance_ami_mongo = "ami-06c5a681179dd8475"

instance_type = "i3.xlarge"

ec2_key = "test_key"


ec2_mongo_name = "mongo-primary"

instance_ami_mongo_sec = "ami-0836ff774af16b5a1"

ec2_mongo_name_sec = "mongo-secondary"

instance_ami_redis = "ami-0fda81f340ba1e0b5"

instance_type_redis = "m5.large"

ec2_redis_name_app = "Redis-app"

ec2_redis_name_app2 = "Redis-app2"

instance_ami_rabbit = "ami-03bf06a49586e308c"

instance_type_rabbit = "m5.large"

ec2_rabbit_name = "RabbitMQ"

instance_ami_eslb = "ami-0cfaf14cfc467a59a"

instance_type_eslb = "m5.large"

ec2_eslb_name = "ElasticSearch-app3"

min_size_app = "1"

max_size_app = "3"

instance_ami_app = "ami-0c8ca3ca0c334d9b6"

iam_role = "S3ReadOnly"

instance_type_app = "m5.large"

min_size_app2 = "1"

max_size_app2 = "3"

instance_ami_app2 = "ami-0368a3c42ef6d1e17"

instance_type_app2 = "m5.large"

asg_name_app = "app-asg"

asg_name_app2 = "app2-asg"

asg_name_app3 = "app3-asg"

min_size_app3 = "1"

max_size_app3 = "3"

instance_ami_app3 = "ami-0bd6173862bc7eb7e"

instance_type_app3 = "m5.large"

app_alb_name = "app-ALB"

s3_bucket =  "Sread"

target_group_name_app = "app-Targetgroup"

app_port = "3000"

target_group_sticky = "true"

target_group_path = "/api/v1/health/heartbeat"

target_group_port = "3000"

app2_alb_name = "app2ALB"

target_group_name_app2 = "TargetGroupapp2"

app2_port = "3000"

target_group_path_1 = "/v1/health/heartbeat"

target_group_port_1 = "3000"

app3_alb_name = "app3ALB"

target_group_name_app3 = "TargetGroupapp3"

app3_port = "4000"

target_group_path_2 = "/v1/health/heartbeat"

target_group_port_2 = "4000"

record_set_name_app_redis = "app-redis.bykea.prod."

record_set_name_app2_redis = "app2-redis.bykea.prod."

record_set_name_app_mongomaster = "mongo-master.bykea.prod."

record_set_name_app_mongosecondary = "mongo-read.bykea.prod."

record_set_name_app_rabbit = "rabbit.bykea.prod."

record_set_name_app3_es = "eslb.bykea.prod."
}