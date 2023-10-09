#!/bin/sh

# If no env var for FTP_USER has been specified, use 'admin':
if [ "$FTP_USER" = "**String**" ]; then
  export FTP_USER='admin'
fi

# If no env var has been specified, generate a random password for FTP_USER:
if [ "$FTP_PASS" = "**Random**" ]; then
  export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
fi

# Set passive mode parameters:
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
  # export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
  export PASV_ADDRESS=$(curl -s -4 --connect-timeout 5 --max-time 10 ifconfig.co)
fi

if [ "$FTP_SSL" == "yes" ] ; then 
openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -subj "/C=/ST=/O="

echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" >> /etc/vsftpd/vsftpd.conf
echo "rsa_private_key_file=/etc/ssl/private/vsftpd.pem" >> /etc/vsftpd/vsftpd.conf
echo "ssl_enable=YES" >> /etc/vsftpd/vsftpd.conf
echo "allow_anon_ssl=NO" >> /etc/vsftpd/vsftpd.conf
echo "force_local_data_ssl=YES" >> /etc/vsftpd/vsftpd.conf
echo "force_local_logins_ssl=YES" >> /etc/vsftpd/vsftpd.conf
echo "ssl_tlsv1=YES" >> /etc/vsftpd/vsftpd.conf
echo "ssl_sslv2=NO" >> /etc/vsftpd/vsftpd.conf
echo "ssl_sslv3=NO" >> /etc/vsftpd/vsftpd.conf
echo "require_ssl_reuse=NO" >> /etc/vsftpd/vsftpd.conf
echo "ssl_ciphers=HIGH" >> /etc/vsftpd/vsftpd.conf

fi

if [ -z "$(grep "pasv_max_port=" /etc/vsftpd/vsftpd.conf)" ]; then
  echo -e "\n## passive mode port address" >> /etc/vsftpd/vsftpd.conf
  echo "pasv_max_port=$PASV_MAX_PORT" >> /etc/vsftpd/vsftpd.conf
  echo "pasv_min_port=$PASV_MIN_PORT" >> /etc/vsftpd/vsftpd.conf
  echo "pasv_address=$PASV_ADDRESS" >> /etc/vsftpd/vsftpd.conf
fi


# fix ftp home permissions
chown -R virtual:virtual /home/ftp/

# Run vsftpd:
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
