# vsftpd-alpine-docker
## alpine base dockerized vsftpd 

### adduser 
mkdir -p /home/ftp/mypractice
echo "mypractice:$(openssl passwd -1 password)" >> /etc/vsftpd/users/virtual_users
cat > /etc/vsftpd/vsftpd_user_conf/mypractice <<EOF
anon_world_readable_only=NO
write_enable=YES
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO
local_root=/home/ftp/mypractice
EOF

chown -R virtual:virtual /home/ftp/
