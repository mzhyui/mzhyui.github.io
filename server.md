# V2ray
## 主要结构：v2fly.org
> https://github.com/v2fly/v2ray-core

```bash
# 安裝執行檔和 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
# 只更新 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
```


## execute as user1
```bash
su -c '/home/user1/test.sh' user1
```

## 配置websocket
> https://www.misterma.com/archives/856/#comment-735

## config
```json
{
  "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "level": "info"
  },
  "inbounds": [
    {
      "port": 8080, // 服务器监听端口
      //"listen": "127.0.0.1",
      "protocol": "vmess",    // 主传入协议
      "settings": {
        "clients": [
          {
            "id": "yourID",  // 用户 ID，客户端与服务器必须相同
            "level": 1,
            "alterId": 0
          }
        ]
      }
    },
    {
      "port": 443,
      //"listen": "127.0.0.1",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "yourID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "serverName": "serverName",
          "allowInsecure": false,
          "certificates": [
            {
              "certificateFile": "/usr/local/etc/v2ray/fullchain.pem",
              "keyFile": "/usr/local/etc/v2ray/privkey.pem"
            }
          ]
        },
        "wsSettings": {
          "path": "/",
          "headers": {}
        }
      },
      "tag": "",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",  // 主传出协议
      "settings": {}
    }
  ],
  "transport": {
      "wsSettings":{
          "acceptProxyProtocol": false,
          "path": "/",
          "headers": {
              "Host": "serverName"
          }
      }
  }
}
```

## uuid

```bash
cat /proc/sys/kernel/random/uuid
```

## 端口防火墙
```bash
ufw reload
ufw allow 12333
```

```bash
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
```
or
```bash
iptables-save > iptables.bak
iptables-restore iptables.bak
```

ssh has been changed to socket mode. Modification of /etc/systemd/system/ssh.service.d/00-socket.conf may be needed.
> https://discourse.ubuntu.com/t/sshd-now-uses-socket-based-activation-ubuntu-22-10-and-later/30189/11

and modify the sshd_config
```
# At the end of the file
ChallengeResponseAuthentication no

Match User *
    PasswordAuthentication no
```

## Timezone/Time update
```bash
ntpdate -u time.nist.gov
tzselect
```
## ssl证书

letCert sign
```bash
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
```

```bash
#pfx
openssl pkcs12 -in webvt.mzhyui.cn.pfx -nodes -out webvt.mzhyui.cn.pem
openssl rsa -in webvt.mzhyui.cn.pem -out webvt.mzhyui.cn.key

#pem
openssl x509 -in /etc/letsencrypt/live/free.mzhyui.com/fullchain.pem -out /etc/letsencrypt/live/free.mzhyui.com/fullchain.crt
openssl rsa -in /etc/letsencrypt/live/free.mzhyui.com/privkey.pem -out /etc/letsencrypt/live/free.mzhyui.com/privkey.key
```
## outbounds

```json
"outbounds": [{
    // Protocol name of the outbound proxy.
    "protocol": "vmess",

    // Settings of the protocol. Varies based on protocol.
    "settings": {
      "vnext": [
        {
          "address": "xxx", 
          "port": 443,
          "users": [
            {
              "id": "xxx",
              "alterId": 0
            }
          ]
        }
      ]
    },
    "streamSettings": {
      "network": "ws",
      "security": "tls",
      "wsSettings": {
        "path": "/"
      }
    },
    // Tag of the outbound. May be used for routing.
    "tag": "direct"
  }
```

## v2ray config

### v2ray闪退(windows)
在cmd中打开v2ray.exe可以看到对应stdout


### 目前配置
~~一级代理：华为云，webs.mzhyui.cn，vmess+websocket+tls
一级代理：vultr-jp，webvt.mzhyui.cn，vmess+websocket+tls+ecdn
一级代理：vultr-us，webaws.mzhyui.cn，vmess+websocket+tls+ecdn
一级代理：vultr-tcl，webtcl.mzhyui.cn，vmess+websocket+tls+cdn~~ 

### ecnd
腾讯云添加cdn域名解析，源选择ip，解析域名选择绑定域名。

### 开机自动运行命令
https://blog.csdn.net/weixin_42451919/article/details/88971503

### 关闭密码登录
https://www.jianshu.com/p/cc612e53ac75

```bash
vim /etc/ssh/sshd_config
PasswordAuthentication no
PermitRootLogin no 
```

添加腾讯云ECDN

### 待改进
ssh爆破ip屏蔽
> fail2ban
> 
> https://www.linode.com/community/questions/17788/ddos-on-ssh-port
> 
> https://baijiahao.baidu.com/s?id=1668945207293073822&wfr=spider&for=pc
> 
> https://blog.csdn.net/u013488847/article/details/88596552

恶意命令检测
> https://www.cnblogs.com/sec875/p/10060697.html
> 
> https://blog.csdn.net/whatday/article/details/105000271

# GitHub

## 建仓
github创建新仓库
clone到本地，默认main分支
测试连接
```bash
$ ssh -T git@github.com
```
## 提交
[注意gitignore的编码是否为utf-8](https://stackoverflow.com/questions/3833561/why-doesnt-git-ignore-my-specified-file/48185811#48185811)

```bash
git add .
git commit -m "message"
git push origin main
```
or
```bash
git commit -am "message"
```
### 暂存
```bash
git stash
git stash list
git stahs pop
```
## 分支
```bash
git branch alter_version
git checkout alter_version
# git checkout -b <branch>           create and checkout a new branch
```
### 查看远程分支
```bash
git fetch
git branch -a
```
### 获取远程分支
```bash
git checkout -b alter_version origin/alter_version
```
### 部分文件合并
```bash
git checkout alter_version a.file b.file
```
### 删除远程分支
```bash
git push origin -d alter_version 
```
## 删除
```bash
git rm filename.type
```

### Rebase
to delete a commit/commits from history
```bash
git rebase -i HEAD~3
# The command git rebase -i HEAD~3 means to perform an interactive rebase on the last 3 commits on the current branch,
git rebase -i [commit id]
```
notice that the commit id is the commit before the commit you want to delete
be aware of the untracked files which are created by the commits that deleted

## edit remote link (ssh/https)
```bash
git remote set-url origin [origin here]
```

## 私仓
> [服务器上的 Git - 在服务器上搭建 Git](https://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E5%9C%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E6%90%AD%E5%BB%BA-Git)


# Jupyter
ssl
> http://www.qb5200.com/article/381584.html
> 
启动环境
> https://blog.csdn.net/weixin_44560088/article/details/121050748


# 服务配置
## 公网虚拟局域网
> https://github.com/SoftEtherVPN/SoftEtherVPN_Stable
> https://zhuanlan.zhihu.com/p/414145546
```bash
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
```
## mail
> https://blog.csdn.net/N_jw107/article/details/119521517


## route
To set up block rules from a file using iptables on Linux, you can follow these general steps:

Create a file with the block rules: Create a new file (e.g., blocklist.txt) that contains the IP addresses or CIDR ranges that you want to block, one per line.

Use iptables to add the rules: Run the following commands as root or with sudo privileges to add the block rules to iptables:

```bash
iptables -I INPUT -m set --match-set blocked_ips src -j DROP
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -m set --match-set blocked_ips src -j REJECT --reject-with tcp-reset
# These commands add two rules to iptables: The first rule drops all incoming traffic from IP addresses in the "blocked_ips" set, and the second rule rejects incoming TCP connections to ports 80 and 443 from those IP addresses.

# Load the IP addresses from the file into ipset: Run the following command to create an ipset named "blocked_ips" and load the IP addresses from the file blocklist.txt:
ipset create blocked_ips hash:net
ipset add blocked_ips $(cat /path/to/blocklist.txt)
# Save the iptables and ipset configuration: Run the following commands to save your iptables and ipset configuration so that they persist after a reboot:
service netfilter-persistent save
service ipset-persistent save
# Note that these commands may vary depending on your Linux distribution and version of iptables. Also, make sure to test and verify your configuration before implementing it in a production environment.
```

## redis
```bash
# 配置密码
config get requirepass
config set requirepass "pass"
```

# Port
Having some local servers and a remote server with PUBLIC IP, we can use ssh to build the tunnel.

## Port forwarding
local_server -> remote_server -> desired_server

In this case, the traffic to local_server:local_server_port will be forwarded to the desired_server_ip:desired_server_port, with the remote_server as a bridge.
```bash
ssh -i /path/to/prikey -N -L [0.0.0.0:]local_server_port:desired_server_ip:desired_server_port user@remote_server_ip
```

## Port projecting
other_server -> remote_server -> local_server

In this case, the local server project the local services to the remote server, and other servers can access these services through remote server.
```bash
ssh -i /path/to/prikey -N -R [0.0.0.0:]remote_server_port:localhost:local_server_port user@remote_server_ip
```
If remote_server wants to make the port available on 0.0.0.0, the `AllowTcpForwarding yes; GatewayPorts yes` should be added in /etc/ssh/sshd_config 

# docker

## commands
```bash
docker ps [-a]
docker image ls
docker container ls [-a][-s, --size]
docker system df [-v, --verbose]
```

## 不用sudo
> https://blog.csdn.net/boling_cavalry/article/details/106590784
```bash
#if not docker-compose installed, sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo systemctl restart docker
sudo chmod a+rw /var/run/docker.sock
```


## pytorch
> https://www.jianshu.com/p/0afeacdd7234

## 添加用户组
```bash
$ sudo usermod -a -G docker user

```
## docker添加挂载路径：
> https://segmentfault.com/q/1010000020514283
```bash
docker commit #提交当前容器，储存为新的image
docker save #保存镜像
docker load #加载镜像
docker run #从保存的容器重新运行，可修改挂载/端口等路径
```

## docker+pytorch
Initialize the server with nvidia driver support: (linux version)
> https://www.nvidia.cn/Download/index.aspx?lang=cn


Install nvidia-docker2:
> https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

Pull the pytorch image:
> https://hub.docker.com/r/pytorch/pytorch/tags

Run the image with daemon: (container port 8888->host port 12345)
```bash
docker run --runtime=nvidia -dit -p 12345:8888 -v /home/ubuntu/docker_share:/home/ pytorch/pytorch:<version> /bin/bash
docker exec -it container_id bash
```

Problem: cannot activate nvidia runtime without sudo

## code-server
local server port:0.0.0.0:8080

ipynb fail loading:
> https://zhuanlan.zhihu.com/p/564827656

# python
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.10
```
