# V2ray + CF Wrap

local machine -> v2ray service -> warp-svc -> reverse proxy

## install Wrap
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
