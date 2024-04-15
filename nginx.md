# Nginx multi domain
```conf
# 域名1的配置
server {
    listen 443 ssl;
    server_name www.example1.com;

    ssl_certificate /path/to/ssl/example1.crt;  # SSL 证书路径
    ssl_certificate_key /path/to/ssl/example1.key;  # SSL 密钥路径

    location / {
        proxy_pass http://localhost:8080;  # 将请求转发到内部端口8080
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# 域名2的配置
server {
    listen 443 ssl;
    server_name www.example2.com;

    ssl_certificate /path/to/ssl/example2.crt;  # SSL 证书路径
    ssl_certificate_key /path/to/ssl/example2.key;  # SSL 密钥路径

    location / {
        proxy_pass http://localhost:8090;  # 将请求转发到内部端口8090
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

## port
```conf
server {
    listen [::]:443 ssl ipv6only=on default_server;  # 这是默认的 IPv6 服务器
    server_name www.example1.com;
    # SSL 和其它配置...
}

server {
    listen [::]:443 ssl ipv6only=on;  # 注意这里没有 default_server
    server_name www.example2.com;
    # SSL 和其它配置...
}

```
