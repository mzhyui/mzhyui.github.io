# SSH
```vi
vim /etc/ssh/sshd_config
PasswordAuthentication no
PermitRootLogin no 
Port 1233
```
# User
```bash
sudo adduser username
# sudo usermod -aG sudo username
```
# UFW
```bash
sudo ufw allow OpenSSH
sudo ufw reload
```
