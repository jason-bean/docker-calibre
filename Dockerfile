
FROM phusion/baseimage:0.9.22
LABEL maintainer "taddeusz@gmail.com"

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Configure user nobody to match unRAID's settings
RUN usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /home nobody && \
    chown -R nobody:users /home

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh



RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        python \
        xz-utils \
        libqt5widgets5 && \
    mkdir -p /calibre-library /calibre-import /etc/firstrun /opt/calibre && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
                            /usr/share/man /usr/share/groff /usr/share/info \
                            /usr/share/lintian /usr/share/linda /var/cache/man && \
        (( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
        (( find /usr/share/doc -empty|xargs rmdir || true ))

ENV CALIBRE_VER=3.15.0
RUN wget -O- https://github.com/kovidgoyal/calibre/releases/download/v${CALIBRE_VER}/calibre-${CALIBRE_VER}-x86_64.txz | tar -xJ -C /opt/calibre

COPY calibre-server.sh /etc/service/calibre-server/run
COPY firstrun.sh /etc/my_init.d/firstrun.sh
COPY metadata.db /etc/firstrun
RUN chmod +x /etc/service/calibre-server/run && \
    chmod +x /etc/my_init.d/firstrun.sh && \
    (crontab -l 2>/dev/null; echo "*/10 * * * * /opt/calibre/calibredb add /calibre-import/ -r --with-library http://localhost:8080/#calibre-library && rm /calibre-import/*") | crontab -

VOLUME ["/calibre-library"]
VOLUME ["/calibre-import"]
EXPOSE 8080