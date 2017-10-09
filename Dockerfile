
FROM phusion/baseimage:0.9.18
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
apt-get install -y \
wget \
python \
xvfb \
ImageMagick

RUN mkdir -p /calibre-library /calibre-import

RUN wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/opt/', True)"

COPY calibre-server.sh /etc/service/calibre-server/run
RUN chmod +x /etc/service/calibre-server/run

#RUN echo "*/10 * * * * xvfb-run calibredb add /calibre-import/ -r --with-library /calibre-library && rm /calibre-import/*" >> /etc/cron.d/calibre-import
RUN (crontab -l 2>/dev/null; echo "*/10 * * * * xvfb-run calibredb add /calibre-import/ -r --with-library /calibre-library && rm /calibre-import/*") | crontab -

VOLUME ["/calibre-library"]
VOLUME ["/calibre-import"]
EXPOSE 8080