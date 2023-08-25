 #!/bin/bash
#install MySQL
sudo yum update -y
sudo yum install -y mariadb105-server

# start the engine
sudo systemctl start mariadb

# enable auto-start with system
sudo systemctl enable mariadb