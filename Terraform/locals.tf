locals {
  server_instances = {
    "instance1" = {
      server_name = "IOT"
      ami = "ami-08a52ddb321b32a8c"
      instance_type ="t2.micro",
      instance_profile_name = module.roles.instance_profile_name
      sg_id = module.sg.security_group_name
      subnet_id = module.vpc.subnet_id
      key_name =""
      user_data = data.template_file.user_data.rendered
      volume_size = 8},

    "instance2" = {
      server_name = "Windows_Bastion_Host"
      ami = "ami-09301a37d119fe4c5"
      instance_type ="t2.large"
      instance_profile_name = module.roles.instance_profile_name
      sg_id = module.sg.security_group_name
      subnet_id = module.vpc.subnet_id
      key_name ="bastion_host_key"
      volume_size =30
      user_data =""}

    "instance3" = {
      server_name = "linux-bastion-host"
      ami = "ami-08a52ddb321b32a8c"
      instance_type ="t2.micro",
      instance_profile_name = module.roles.instance_profile_name
      sg_id = module.sg.security_group_name
      subnet_id = module.vpc.subnet_id
      key_name =""
      user_data = data.template_file.user_data.rendered
      volume_size = 8},


  }
}