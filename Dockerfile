
FROM phusion/baseimage:0.9.18
LABEL maintainer "taddeusz@gmail.com"

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y \
wget \
python \
xdg-utils \
ImageMagick

RUN mkdir -p /calibre-library /calibre-import

RUN wget --no-check-certificate -nv -O- https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main('/opt/', True)"

COPY calibre-server.sh /etc/service/calibre-server/run

RUN echo "*/10 * * * * xvfb-run calibredb add /calibre-import/ -r --with-library /calibre-library && rm /calibre-import/*" >> /etc/cron.d/calibre-import

VOLUME ["/calibre-library"]
VOLUME ["/calibre-import"]
EXPOSE 8080
USER nobody