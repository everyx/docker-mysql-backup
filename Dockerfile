FROM debian:buster-slim

ENV MYSQL_USER ""
ENV MYSQL_PASSWORD ""
ENV MYSQL_HOST ""
ENV MYSQL_PORT "3306"
ENV MYSQL_DATABASES ""
ENV RCLONE_DEST ""

RUN apt-get update -qq \
    # install oracle mysql-client
    && depends="lsb-release wget gnupg" && apt-get install -qq -y $depends \
    && wget -q https://dev.mysql.com/get/mysql-apt-config_0.8.18-1_all.deb \
    && DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_*_all.deb \
    && rm mysql-apt-config_*_all.deb \
    && apt-get update -qq \
    && apt-get install -qq -y -o=Dpkg::Use-Pty=0  mysql-client \
    && apt-get remove -y $depends \
    # install rclone
    && apt-get install -qq -y -o=Dpkg::Use-Pty=0  rclone \
    # clean up
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY backup.sh /
CMD ["/bin/sh", "/backup.sh"]
