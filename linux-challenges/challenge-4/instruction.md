#### find hidden files in /home/bob/preserved and copy to /opt/appdata/hidden
```
mkdir -p /opt/appdata/hidden

find /home/bob/preserved -type f -name ".*" -exec cp "{}" /opt/appdata/hidden \;
```

#### find non-hidden files in /home/bob/preserved and copy to /opt/appdata/files

mkdir -p /opt/appdata/files

find /home/bob/preserved -type f -not -name ".*" -exec cp "{}" /opt/appdata/files \;

#### find and delete the files in /opt/appdata which have a word ending the letter "t"

find /opt/appdata -type f -exec grep -lE 't\b' {} \; -delete

> /b is word boundary, pemisah kata.


#### change all word "yes" to "no" all files under /opt/appdata

find /opt/appdata -type f -exec sed -i 's/\byes\b/no/g' "{}" \;

#### change all word "raw" to "processed" all files under /opt/appdata, case sensitive replace raw, Raw, RAW.

find /opt/appdata -type f -exec sed -i 's/\braw\b/processed/ig' "{}" \;

> flag i is case sensitive


#### create tar.gz

tar -czvf /opt/appdata.tar.gz /opt/appdata

> c create, z gzip, v verbose, f file.

#### create softlink ~/appdata.tar.gz of /opt/appdata.tar.gz

ln -s /opt/appdata.tar.gz /home/bob/appdata.tar.gz


#### add sticky bit on /opt/appdata

chmod +t /opt/appdata

#### make owner:group, bob:group of /opt/appdata.tar.gz

chown bob:bob /opt/appdata.tar.gz

#### owner:group have read only and others not have any permissions

chmod 440 /opt/appdata.tar.gz

#### the script filter lines from /opt/appdata.tar.gz which contain the word "processed" and save /home/bob/filtered.txt. it must overwrite.

#!/bin/bash

tar -xzOf /opt/appdata.tar.gz | grep -i processed > /home/bob/filtered.txt
