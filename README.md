# Mergin Maps + Docker Setup Guide

> **DISCLAIMER**  
> The information provided in this tutorial is for educational purposes only.  
> By following this tutorial, you assume all risks and responsibilities associated with modifying configuration files.  
> We do not guarantee the accuracy, completeness, or functionality of the changes made in your specific environment.  
> **USE AT YOUR OWN RISK.** We claim no liability for any damages or losses that may occur.

---

## 📹 Video Tutorials
- **Video 1:** [Introduction](https://youtu.be/fRnlBNpX1p0)
- **Video 2:** [GCP and Virtual Machine Setup](https://youtu.be/Gt84lpa8ie4)
- **Video 3:** [Setting up SSL/HTTPS on a Virtual Machine Using Docker and Certbot](https://youtu.be/-bZqrHo3WGI)
- **Video 4:** [Coming Soon]()

---

# VIDEO 2 STARTS HERE
### 1. Fresh Install & Docker Setup

```bash
sudo apt-get update
```

#### Install Git
```bash
sudo apt-get install git-all
```

#### Install Docker and Docker Compose
```bash
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add Docker repository to Apt sources:
```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker packages:
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Verify Docker installation:
```bash
sudo docker run hello-world
```

#### Allow Docker to run without sudo
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```


# VIDEO 3 STARTS HERE
## 🛑 Stop Apache (If Installed)

```bash
sudo systemctl stop apache2
sudo systemctl disable apache2
sudo apt remove --purge apache2 -y
sudo apt autoremove -y
```

---

## 🌐 NGINX + Certbot Setup (Video 3)

```bash
git clone https://github.com/geoace/certbot-nginx.git
cd certbot-nginx
chmod +x start-nginx.sh
mkdir conf
cp .env.template .env
nano .env
```

Start containers:
```bash
docker compose up -d
```

Visit your server at `http://<your-vm-ip>` to verify the homepage.

If working, clean up:
```bash
docker rm certbot nginx helloworld -f
docker rmi certbot/certbot nginx crccheck/hello-world
```

Link DNS zones and nameservers with GCP.

Once DNS is configured:
```bash
docker compose up
```

After verifying SSL certs:
```bash
docker rm $(docker ps -aq) -f
docker compose up -d
```

Visit `https://yourdomain.com` to verify HTTPS.

---

# VIDEO 4 STARTS HERE
## 🗃️ Mergin Maps Stack Setup

Remove SSL setup from the last video
```bash
docker rm $(docker ps -aq) -f
docker rmi $(docker images -q) -f
sudo rm -r certbot-nginx
```

Clone Mergin Maps Server
```bash
cd # go to your base directory
mkdir postgis_data
git clone https://github.com/MerginMaps/server.git mergin
sudo rm -r mergin/.git
```

Add GEOACE remote and merge:
```bash
cd # go to base directory
git clone https://github.com/geoace/mergin_tutorials
cp -r mergin_tutorials/. mergin/
sudo rm -r mergin_tutorials
```

Prepare environment files:
```bash
chmod +x start-nginx.sh
cp .env.template .env
nano .env
nano .prod.env
```

> 💡 Use app passwords for Gmail from: https://myaccount.google.com/apppasswords
> NOTE THAT THIS REQUIRES TWO FACTOR AUTHENTICATION ON YOUR GMAIL ACCOUNT. YOU CAN TURN IT ON BY GOING HERE:
> https://myaccount.google.com/security

Create project directory and set permissions:
```bash
mkdir -p projects
sudo chown -R 901:999 ./projects/
sudo chmod g+s ./projects/
```

Start the stack:
```bash
# Remove Dry Run under certbot command and save
nano docker-compose.yml

# Run the stack to get certs
docker compose up

# Control + C to tear stop the stack, then remove the container stack
docker rm $(docker ps -aq) -f

# Run the stack with HTTPS configuration
docker compose up -d
```

---

### 🔐 First-Time Database Initialization

```bash
docker exec merginmaps-server flask init-db
docker exec merginmaps-server flask user create <username> <password> --is-admin --email <email>
```

---

## ✅ All Set!

Your server is now running Mergin Maps with Docker and SSL via NGINX.
