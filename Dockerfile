FROM alpine:3.13

RUN set -ex \
    && apk add --no-cache ca-certificates curl shadow build-base linux-pam-dev unzip vsftpd openssl \
    && rm -rf /tmp/* /var/cache/apk/*

# make pam_pwdfile.so
COPY libpam-pwdfile.zip /tmp/

RUN set -ex \
    && unzip -q /tmp/libpam-pwdfile.zip -d /tmp/ \
    && cd /tmp/libpam-pwdfile \
    && make install \
    && rm -rf /tmp/libpam-pwdfile \
    && rm -f /tmp/libpam-pwdfile.zip

ENV FTP_USER **String**
ENV FTP_PASS **Random**
ENV PASV_ADDRESS **IPv4**
ENV PASV_MIN_PORT 40000
ENV PASV_MAX_PORT 40100
ENV FTP_SSL=no


COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd.sh /usr/sbin/
COPY vsftpd_virtual /etc/pam.d/

RUN set -ex \
    && chmod +x /usr/sbin/vsftpd.sh \
    && mkdir -p /var/log/vsftpd/ \
    && mkdir -p /etc/vsftpd/vsftpd_user_conf/ \
    && useradd vsftpd -s /sbin/nologin \
    && useradd virtual -m -d /home/ftp/ -s /sbin/nologin \
    && chown -R virtual:virtual /home/ftp/

VOLUME /home/ftp
VOLUME /etc/vsftpd/users/
VOLUME /etc/vsftpd/vsftpd_user_conf/
VOLUME /var/log/vsftpd

EXPOSE 20 21 21100-21110

CMD ["/usr/sbin/vsftpd.sh"]
