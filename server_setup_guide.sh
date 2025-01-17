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
git clone https://github.com/MerginMaps/server.git
mv server mergin
sudo rm -r server
cd mergin
rm .prod.env
# MAKE THIS FILE SPECIFIC TO YOUR DEPLOYMENT AND PASTE IT IN AFTER RUNNING THE NEXT COMMAND: https://github.com/geoace/mergin_tutorials/blob/main/.prod.env 
# If using GMAIL account, then MAIL_PASSWORD should be generated at https://myaccount.google.com/apppasswords
nano .prod.env

#################################################################### STOP VIDEO 4
#################################################################### START VIDEO 5 HERE
rm nginx.conf
nano nginx.conf
# MODIFY AND PASTE CONTENT FROM https://github.com/geoace/mergin_tutorials/blob/main/nginx.conf
# But change server_name on 80 and 443 code blocks as necessary
# Same with SSL Certificates

# docker compose file
rm docker-compose.yml
# MAKE THIS FILE SPECIFIC TO YOUR DEPLOYMENT AND PASTE CONTENT FROM https://github.com/geoace/mergin_tutorials/blob/main/docker-compose.yml
nano docker-compose.yml


#################################################################### STOP VIDEO 5
#################################################################### START VIDEO 6 HERE
#################################################################### STOP VIDEO 6
#################################################################### START VIDEO 7 HERE

