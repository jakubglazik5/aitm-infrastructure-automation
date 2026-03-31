# Deployment and Usage Guide

## Prerequisites
1. A clean VPS server with the **Ubuntu** OS.
2. A web domain with an `A` record and wildcard subdomain `*` pointing to your VPS IP address.

---

## Step 1: Installing GIT and Ansible locally on your computer (if you don't have them installed yet)
For Debian/Ubuntu-based distributions (e.g., Linux Mint): 
```bash
sudo apt update
```
```bash
sudo apt install git
```
```bash
sudo apt install ansible
```

## Step 2: Cloning the Repository
Download the project code to your local computer:
```bash
git clone https://github.com/jakubglazik5/aitm-infrastructure-automation.git
```

## Step 3: Generating an SSH Key
Generate a key using the command (it's best to leave the default .ssh folder):
```bash
ssh-keygen -t ed25519 -C "name to keep things organized (e.g., evilginx_key)"
```
Add the key to your server

## Step 4: Configuration
Navigate to the configuration folder:
```bash
cd aitm-infrastructure-automation/ansible_with_docker
```
Open the inventory.ini file and enter your server's IP address and the path to your PRIVATE SSH key (without the .pub extension):
```bash
nano inventory.ini
```

Save the changes and exit the editor:

Ctrl+o

ENTER

Ctrl+x


## Step 5: Infrastructure Deployment
Run the ansible playbook using the command:
```bash
ansible-playbook -i inventory.ini ansible/deploy_app.yml
```

## Step 6: Managing the Firewall and SSL Certificates:
For Evilginx to work correctly, it needs up-to-date SSL certificates, and our firewall configuration with geoblocking allows network traffic only from Polish IP addresses, protecting the server from most scanners (most scanners come from cybersecurity companies in the US), but it also prevents downloading certificates.

The solution is two scripts sent to the server via ansible: open_ports.sh and close_ports.sh. 

The open_ports.sh script is used to allow traffic in order to download certificates, and close_ports.sh to restore the secure configuration protecting us from scanners.
In addition to these two files, I also included a script updating the list of Polish (default, you can change it to another country) IP addresses. It is worth using it from time to time.

We connect to the server (e.g., using the previously generated key that we added to our server):
```bash
ssh root@YOUR_SERVER_IP_ADDRESS
```

Update the list of Polish IP addresses:
```bash
cd ~/firewall_scripts
```
```bash
./update_ips.sh
``` 

We open the traffic to download certificates (the shorter the ports are exposed to the world, the fewer scanners will manage to check our server):
```bash
./open_ports.sh
```

Launch the evilginx console:
```bash
docker attach evilginx_server
```
If nothing appears in the terminal, press Enter a few times. The prompt ":" should appear. This means the tool is running and we are in the main console.

For the tool to work properly, we need to configure our domain and the server's IP address:
```bash
config domain YOUR_DOMAIN_NAME
```
```bash 
config ipv4 YOUR_SERVER_IP_ADDRESS
```

We check if downloading certificates is possible using the example included with the tool:
```bash
phishlets hostname example YOUR_DOMAIN_NAME
```

```bash
phishlets enable example
```

After successfully downloading the certificates, we exit evilginx, reseal our firewall, and return to the tool:

Ctrl+P

Ctrl+Q

```bash
./close_ports.sh
```

As for using the tool itself and writing your own phishlets, I refer you to the course by the tool's author Kuba Gretzky and tutorials on YouTube.

## Useful Commands and Keyboard Shortcuts:
Completely shutting down the tool at the docker level:
```bash
docker compose down
```

Bringing up the container after a complete shutdown:
```bash
docker compose up -d
```

Stopping the tool at the docker level:
```bash
docker compose stop
```

Starting a STOPPED container:
```bash
docker compose start
```

Running the tool:
```bash
docker attach evilginx_server
```

Exiting the tool console while leaving it running in the background:

Ctrl+P

Ctrl+Q


Exiting the tool console and terminating the process:
```bash
exit
```

Entering the phishlets folder:
```bash
cd /opt/evilginx/phishlets
```

## Firewall Advice
Geoblocking protects us from most scanners, however, Poland also has its own bots scanning the internet in search of such servers. If the configuration is not used as a presentation/training, but only for home tests, I recommend setting up a second firewall directly in your VPS provider's panel. This will drastically increase the lifespan of your server.

In the panel, we set TCP ports 22, 80, and 443 to the public address of our home router. 22 is optional but protects the server against brute-force attacks on the SSH protocol.

Such a configuration will stop the rest of the scanners, which will allow for peaceful testing within our Wi-Fi network.

When downloading SSL certificates via Let's Encrypt, network traffic must temporarily be allowed through ports 80 and 443 from both firewalls.

You can check your router's public address by connecting to your network and entering the command:
```bash
curl ifconfig.me
```

To switch our geoblocking to the IP addresses of a country other than Poland, simply change the COUNTRY_CODE in the update_ips.sh file. It is best to change this before running the inventory.ini file.

Example based on Germany:
```bash
COUNTRY_CODE="de"
```

If you've finished configuring the server but still want to change the geoblocking settings to another country, in addition to the above script, you'll need to clear all active connections using the following commands:
```bash
sudo apt install conntrack
```
```bash
sudo conntrack -F
```

Link to the page with the list of two-letter country codes used by the script: http://www.ipdeny.com/ipblocks/
