
FROM phusion/baseimage:0.9.18
LABEL maintainer "taddeusz@gmail.com"

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y \
wget \
python \
xdg-utils \
ImageMagick

RUN mkdir -p /calibre-library/toadd /opt/calibre

RUN cd /opt && \
wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/opt/', True)"

VOLUME ["/calibre-library"]
EXPOSE 8080
USER nobody
CMD ["/opt/calibre/calibre-server","--with-library=/calibre-library"]

