# DISCLAIMER:
# The information provided in this tutorial is for educational purposes only.
# By following this tutorial, you assume all risks and responsibilities associated with modifying configuration files.
# We do not guarantee the accuracy, completeness, or functionality of the changes made in your specific environment.
# USE AT YOUR OWN RISK. We claim no liability for any damages or losses that may occur.

#################################################################### VIDEO 3 STARTS HERE: https://youtu.be/fRnlBNpX1p0
# From Fresh Install:
sudo apt-get update
##### Github
sudo apt-get install git-all

##### Docker and Docker Compose workflow
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker run hello-world

# Setup running Docker without sudo (required for Lizmap stack; source: https://docs.docker.com/engine/install/linux-postinstall/)
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
# Verify installation and permissions
docker run hello-world

#################################################################### STOP VIDEO 3 
#################################################################### START VIDEO 4 HERE

# Before getting started: Make sure that APACHE or on-VM NGINX aren't installed. Google cloud sometimes comes with apache installed by default.
# Taken from: git clone https://github.com/geoace/certbot-nginx.git
sudo systemctl stop apache2

sudo systemctl disable apache2

sudo apt remove --purge apache2 -y

sudo apt autoremove -y

#Git clone the repository
git clone https://github.com/geoace/certbot-nginx.git

cd certbot-nginx

# make startup executable
chmod +x start-nginx.sh

# Make conf directories
mkdir conf

# Copy the env file
cp .env.template .env

# Modify the environment variables to suit your deployment
nano .env

docker compose up -d

# Visit the IP address of your virtual machine UNSECURED using HTTP and ensure your home page exists (e.g., http://niner.com)

# Once you've verified that you're up and running, then remove the containers
docker rm $(docker ps -aq) -f

# Set up Domains between GCP and Registrar (Siteground is used in the video tutorial)
# ONCE DNS Zones and Nameservers are linked between GCP and Siteground/registrar:

# Run docker compose to get the certificates
docker compose up

# Exit the containers using Control + C, and then remove them (certificates have been received, but NGINX is still not running via SSL due to configuration file contents; certificates WILL persist)
docker rm $(docker ps -aq) -f

# Run the docker containers
docker compose up -d

# Navigate to https://yourdomain.com to verify that you're running using SSL/HTTPS!

#################################################################### STOP VIDEO 4
#################################################################### START VIDEO 5 HERE


