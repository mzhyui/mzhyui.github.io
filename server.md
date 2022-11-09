# V2ray
### 主要结构：v2fly.org

```bash
# 安裝執行檔和 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
# 只更新 .dat 資料檔
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
```

### 配置websocket
> https://www.misterma.com/archives/856/#comment-735

### uuid

```bash
cat /proc/sys/kernel/random/uuid
```

### 端口
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

### ssl证书

```bash
#pfx
openssl pkcs12 -in webvt.mzhyui.cn.pfx -nodes -out webvt.mzhyui.cn.pem
openssl rsa -in webvt.mzhyui.cn.pem -out webvt.mzhyui.cn.key

#pem
openssl x509 -in fullchain.pem -out fullchain.crt
openssl rsa -in privkey.pem -out privkey.key
```
### outbounds

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
### v2ray闪退
在cmd中打开v2ray.exe可以看到对应stdout

### 无数据传入
检查服务器端防火墙
```bash
ufw reload
ufw allow 12333
```

## 目前配置
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

# GitHub坑记
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
git commit -m "message“
git push origin main
```
暂存
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
查看远程分支
```bash
git fetch
git branch -a
```
获取远程分支
```bash
git checkout -b alter_version origin/alter_version
```
部分文件合并
```bash
git checkout alter_version a.file b.file
```
删除远程分支
```bash
git push origin -d alter_version 
```
## 删除
```bash
git rm filename.type
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

# docker
不用sudo
> https://blog.csdn.net/boling_cavalry/article/details/106590784

pytorch
> https://www.jianshu.com/p/0afeacdd7234

添加用户组
```bash
$ sudo usermod -a -G docker user

```
docker添加挂载路径：
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

## python
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.10
```
