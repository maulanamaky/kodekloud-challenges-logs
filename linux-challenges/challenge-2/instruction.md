### Challenge 2

#### Login as root
```
sudo -i
```
---

#### Fix DNS, cant resolve
```
vi /etc/hosts
```
add
```
nameserver  8.8.8.8
```
---

#### install packages
```
dnf install nginx firewalld -y
```
---

#### start and enable firewalld
```
systemctl enable firewalld --now
```
---

#### add firewall rules
```
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8081/tcp --permanent
firewall-cmd --reload
```
---

#### Start go-app
```
pushd /home/bob/go-app
nohup go run main.go &
popd
```
---

#### Configure Nginx
```
vi /etc/nginx/nginx.conf
```
edit to like this
```
server {
  listen       80;
  listen       [::]:80;
  server_name  _;
  root         /usr/share/nginx/html;

  # Load configuration files for the default server block.
  include /etc/nginx/default.d/*.conf;

  location = / {
    proxy_pass  http://localhost:8081;
  }

  error_page 404 /404.html;
  location = /404.html {
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
  }
}
```
#### Start and enable nginx
```
systemctl enable nginx --now
```
---
