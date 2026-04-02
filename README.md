**[Polska_Wersja](README_pl.md)**

# Adversary-in-the-Middle (AitM) Infrastructure Automation

## About the Project
I created this project to practically learn automation, containerization, firewall configuration, and to gain a deeper understanding of the mechanics of advanced phishing attacks, and most importantly, methods of effective defense against them. I became interested in this topic during lectures and project classes in the Web Application Development course at the Gdańsk University of Technology.

## Why AitM and session hijacking?
Classic phishing is losing its effectiveness. The modern approach uses the **Adversary-in-the-Middle (AitM)** technique with reverse proxy servers. This attack allows intercepting not only login credentials but, more importantly, the session tokens of an authenticated user. Possessing such a token allows bypassing Multi-Factor Authentication (MFA/2FA) mechanisms, making this attack vector exceptionally dangerous.

## Operational Challenge and Solution
Test servers exposed to the internet are instantly flagged and blocked by automated security scanners. Attackers use advanced code obfuscation techniques, separate servers for the tool and the spoofed website, and tunneling via Cloudflare to hide from detection. For our testing purposes, a firewall with configured geoblocking is sufficient, which will allow traffic exclusively from Polish IP addresses or solely from the address associated with our home router – depending on whether we use the configuration to check our own devices, or we are preparing a live demonstration with participants.

To solve the problem of continuous and tedious environment configuration, I implemented the **Infrastructure as Code** approach. 
Using **Ansible**, I automated the entire lifecycle of deploying the new infrastructure. The playbooks automatically:
* Configure the Linux system.
* Manage network traffic (GeoIP firewalls using `iptables`).
* Run the application in an isolated **Docker** environment (optional).

Thanks to this, the deployment of a fully operational server secured against scanners takes just a few minutes.

## Disclaimer
This project is strictly educational. The repository does not contain ready-made templates (phishlets) that allow conducting an attack on real services. However, it will save a lot of time for those who want to test the vulnerability of their own web application or are simply curious about what such an attack looks like in practice.

## A few deployment tips
* **Ansible version:** Much more convenient to use if the VPS server is strictly for quick tests using Evilginx. 
* **Ansible with Docker version:** Recommended if you care about full environment isolation, lack of dependency conflicts in the main operating system, and the ability to instantly remove the tool from the server.
