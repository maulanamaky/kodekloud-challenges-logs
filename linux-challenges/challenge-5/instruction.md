### Challenge 5

#### Login as root
```
sudo -i
```
---

#### install mariadb and start also enable
```
dnf install mariadb-server -y

systemctl enable mariadb --now
```
---

#### set mysql password
```
mysqladmin -u root password "<PASSWORD>"
```
---

#### unlock root and append root to wheel group
```
usermod -U root

usermod -aG wheel root
```
---

#### pull nginx image docker
```
docker pull nginx
```
---

#### run container nginx image, the name is myapp, port host is 80 and port container is 80
```
docker run -d -p 80:80 --name myapp nginx
```
---

#### script container-started.sh for start the container
```
#!/bin/bash

docker start myapp
echo "myapp container started!"
```
---

#### script container-stop.sh for stop the container
```
#!/bin/bash

docker stop myapp
echo "myapp container stopped!"
```
---

#### add to cronjob, which should run container-stop.sh at 12am everyday and should run container-start.sh at 8am everyday
```
crontab -e
```
add this configure
```
0 0 * * *   /home/bob/container-start.sh
0 8 * * *   /home/bob/container-stop.sh
```
---

#### edit pam
```
vi /etc/pam.d/su
```
> uncomment #auth which relate to wheel group.
