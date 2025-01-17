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
##### MERGIN MAPS. 
# https://github.com/geoace/enterprise_setup_and_customization/blob/main/mergin_server_setup.md
git clone https://github.com/MerginMaps/server.git
mv server mergin
sudo rm -r server
cd mergin
rm .prod.env
# MAKE THIS FILE SPECIFIC TO YOUR DEPLOYMENT AND PASTE IT IN AFTER RUNNING THE NEXT COMMAND: https://github.com/geoace/mergin_tutorials/blob/main/.prod.env. 
# If using GMAIL account, then MAIL_PASSWORD should be generated at https://myaccount.google.com/apppasswords
nano .prod.env

#################################################################### STOP VIDEO 4
#################################################################### START VIDEO 5 HERE
rm nginx.conf
nano nginx.conf
# PASTE CONTENT FROM https://github.com/geoace/enterprise_setup_and_customization/blob/main/mergin_nginx.conf
# But change server_name on 80 and 443 code blocks as necessary
# Same with SSL Certificates
rm docker-compose.yml
nano docker-compose.yml
# PASTE CONTENT FROM https://github.com/geoace/enterprise_setup_and_customization/blob/main/mergin_docker-compose.yml

# Get the ID of the new container
docker container ls -a
# Set the crontab to start the container on reboot
crontab -e
# Paste this line in crontab and save:
@reboot docker start bc8461 # @reboot docker start *unique portion of container ID*

##### SSL
sudo apt update
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx

#You'll be prompted to fill out the following:

#email address: getstarted@geoace.net

#y

#n

#domain name (modify to your domain name as necessary): field.geoace.net

#Then set up auto-renewal:
crontab -e
# Set this up in crontab:
0 0,12 * * * /usr/bin/certbot renew --quiet

sudo systemctl stop apache2
sudo systemctl disable apache2
sudo apt-get purge apache2 apache2-utils apache2-bin apache2.2-common




##### SET UP DBSYNC
# PREREQUISITES:
# 1. Have GeoPackage or PostgreSQL Database schema ready to go
# 2. If using a PostGIS database, then create empty project in mergin maps to receive the schema. Make sure an empty QGIS project/file is in there as well. This should be the only file in the project.
# NOTE: It is recommended to start with a geopackage, take it as far as you can with regard to schemas, then use the below dbsync to make it in PostGIS. From there you can proceed with the automation. I ran into LOTS of issues starting with PG first and then migrating to a geopackage. So it's probably best to start simple (geopackage) for a proof of concept and then scale up. 
mkdir dbsync
cd dbsync
nano config.yaml
# configure project info
# example at https://github.com/geoace/enterprise_setup_and_customization/blob/main/mergin_dbsync_config.yaml
docker run -it -v ${PWD}:/config lutraconsulting/mergin-db-sync:latest /config/config.yaml
# Set to automatically run after reboot
crontab -e
# Add the following line:
@reboot docker start ef0705a1d69d

