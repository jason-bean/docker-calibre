
FROM jeanblanchard/alpine-glibc:3.7
LABEL maintainer "taddeusz@gmail.com"

ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
ENV LD_LIBRARY_PATH /usr/lib:/usr/local/lib:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin

RUN apk update && \
    apk add --no-cache --upgrade \
    bash \
    ca-certificates \
    python \
    tini \
    supervisor \
    qt5-qtbase-x11 \
    wget \
    xz && \
    wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)" && \
    rm -rf /tmp/calibre-installer-cache && \
    apk del ca-certificates wget xz

COPY firstrun.sh /firstrun.sh
COPY calibre-import.sh /etc/periodic/15min/calibre-import
COPY metadata.db /etc/firstrun/metadata.db
COPY supervisord.conf /etc/supervisord.conf
RUN chmod +x /firstrun.sh && \
    chmod +x /etc/periodic/15min/calibre-import

VOLUME ["/calibre-library"]
VOLUME ["/calibre-import"]
EXPOSE 8080

CMD [ "/firstrun.sh" ]