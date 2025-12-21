### LVM for directory DB

#### Login as a root
```
sudo -i
```
---
#### Partitions disks with fdisk for /dev/vdb and /dev/vdc
```
fdisk /dev/vdb
```
> [INFO: Fill the answer]
> - n for make new partitions
> - 1 for only 1 partitions
> - skip
> - skip
> - w for write and quit
---

#### Make Persistent Volume
```
pvcreate /dev/vdb1 /dev/vdc1
```

#### Make Volume Group
```
vgcreate dba_storage /dev/vdb1 /dev/vdc1
```

#### Make Logical Volume
```
lvcreate -n volume_1 -l 100%FREE dba_storage
```
> [INFO]
> - use flag `-l 100%FREE` for get all storage available from VG.
> - use flag `-L 500M` for get some storage available from VG. 
---

#### Format with XFS
```
mkfs.xfs /dev/dba_storage/volume_1
```
---

#### Mount to /mnt/dba_storage
```
mkdir /mnt/dba_storage
mount /dev/dba_storage/volume_1 /mnt/dba_storage
```

#### Make persistent for reboot
- open /etc/fstab
```
sudo vi /etc/fstab
```
- append this code
```
/dev/mapper/dba_storage-volume_1 /mnt/dba_storage xfs defaults 0 0
```
> [INFO]
> - use command `lvdisplay` for get information /dev/mapper/dba_storage-volume_1
> - use command `lsblk /dev/mapper/dba_storage-volume_1` for get UUID.
---

#### Make new group dba_users and merge bob user to this group, 
```
groupadd dba_users
usermod -aG dba_users bob
```
#### Make group dba_users for dba_storage and full permission for owner and group and not have any for other.
```
chown :dba_users /mnt/dba_storage
chmod 700 /mnt/dba_storage
```


