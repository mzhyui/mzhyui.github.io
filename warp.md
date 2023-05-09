# V2ray + CF Warp

local machine -> v2ray service -> warp-svc -> reverse proxy

## install Warp
> https://pkg.cloudflareclient.com/packages/cloudflare-warp
or
> https://developers.cloudflare.com/warp-client/get-started/linux/

## startup
edit /lib/systemd/system/warp-svc.service,append the following lines in [Service] section:
```conf
[Service]
LimitNOFILE=65535
LimitNOFILESoft=65535
```
and
```bash
sudo systemctl daemon-reload
sudo systemctl restart warp-svc
```
help manual:
> https://blog.cloudflare.com/zh-cn/announcing-warp-for-linux-and-proxy-mode-zh-cn/

### client setup
```bash
# 1.
warp-cli register
# 2.
warp-cli set-mode proxy
# 3.
warp-cli enable-always-on
# 4.
warp-cli connect
# test
warp-cli status
export ALL_PROXY=socks5://127.0.0.1:40000
curl ifconfig.me
```
### client setup with Zero trust
Settings -> Warp client -> Device enrollment -> manage rules
```bash
warp-cli teams-enroll [your_name_here] # name is under Zero trust / settings / general
warp-cli teams-enroll-token [full_url_here] # the url can be shown in the webpage
warp-cli connect
```
`problem`: no more v2ray connection if connected

## v2ray setting
```bash
vim /usr/local/etc/xray/config.json
```

```json
## inbounds
"sniffing": {
    "enabled": true,
    "destOverride": ["http", "tls"]
}

## outbounds
 "outbounds": [
        {
            "tag": "default",
            "protocol": "freedom"
        },
        {
            "tag":"socks_out",
            "protocol": "socks",
            "settings": {
                "servers": [
                     {
                        "address": "127.0.0.1",
                        "port": 40000
                    }
                ]
            }
        }
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "socks_out",
                "domain": ["geosite:openai", "DOMAIN-KEYWORD:openai"]
            },
            {
                "type": "field",
                "outboundTag": "default",
                "network": "udp,tcp"
            }
        ]
    }

```

## restart
```bash
sudo systemctl restart v2ray/xray
sudo systemctl status v2ray/xray
```

# V2ray + Github Codespace + dante
local machine -> v2ray service <- ssh port projecting -> dante server
## v2ray server


```json
# outbounds/settings
"settings": {
                "servers": [
                     {
                        "address": "127.0.0.1",
                        "port": 1080,
                        "users":[
                        {
                                "user": "dante",
                                "pass": "password",
                                "level": 0
                        }
                        ]
                    }
                ]
            }
```
## dante server (Codespace server)
> https://www.digitalocean.com/community/tutorials/how-to-set-up-dante-proxy-on-ubuntu-20-04
```bash
#port projecting
ssh -p port -i ~/.ssh/key -N -R 1080:localhost:1080 lighthouse@v2rayserverip
```

```conf
# /etc/danted.conf
logoutput: syslog stdout /var/log/lotsoflogs
user.privileged: root
user.unprivileged: nobody

# The listening network interface or address.
internal: 0.0.0.0 port=1080

# The proxying network interface or address.
external: eth0

# socks-rules determine what is proxied through the external interface.
socksmethod: username

# client-rules determine who can connect to the internal interface.
clientmethod: none

client pass {
    from: localhost to: 0.0.0.0/0
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
```
## more
allow port from ip
```bash
sudo ufw allow from dante_server_ip proto tcp to any port sssh_port
```
