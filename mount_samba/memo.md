1.
sudo vim /etc/samba/smb.conf
add those commands:
[share]
   comment = share folder
   path = /home/xxxl/codehome-sda2-691G
   browseable = yes
   create mask = 0755
   directory mask = 0755
   valid users = xxxl
   force user = xxxl
   force group = xxxl
   public =yes
   available= yes
   writable = no

2.
sudo smbpasswd -a xxxl

3.
mount -t cifs -o username="xxxl",password="ppp" //1.1.1.1/sharelocalmountpoint 

