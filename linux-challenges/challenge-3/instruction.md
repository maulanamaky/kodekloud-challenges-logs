### Permission User & Directory


#### Login as root
```
sudo -i 
```
---

#### Make a new groups
```
groupadd devs admins
```

#### Make and set all user to group also set password with passwd
```
useradd <USER> -s <SHELL> -G <GROUP>
passwd <USER>
```
---

#### Set permission for devs and admins group

- group devs can only run dnf with sudo but without password
```
echo '%devs ALL=(ALL) NOPASSWD: /usr/bin/dnf' | tee /etc/sudoers.d/99-devs-dnf
```
- group admins can run all with sudo without password
```
echo '%admins ALL=(ALL) NOPASSWD: ALL' | tee /etc/sudoers.d/99-admins-all
```
> [!NOTE]
> we can use **which** for get information path like `which dnf`
---

#### Set resource limit for group devs can not run more 30 process and be both "hard" and "soft" limit.
```
echo "@devs    -   nproc    30" >> /etc/security/limits.conf
```
<br>

#### Set disk quota for devs group for limit storage not inode, soft 100MB and hard 500MB for /data.
```
setquota -g devs 100M 500M 0 0 /data
```
---
#### Set permission /data
- Make /data for owner bob and groupd devs, and also set permission to all for owner and group and not have any permission for other.
```
chown bob:devs /data
chmod 770 /data 
```
- Make all user under admins group also can access all permission for /data.
```
setfacl -m g:admins:rwx /data
```
