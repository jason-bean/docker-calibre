FROM jeanblanchard/alpine-glibc:3.7 AS build

ARG CALIBRE_VER=unknown
ENV CALIBRE_INSTALLER_SOURCE_CODE_URL https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py

RUN apk update && \
    apk add --no-cache --upgrade \
    ca-certificates \
    python \
    wget \
    xz

RUN CALIBRE_VER=${CALIBRE_VER} && \
    wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main(install_dir='/opt', isolated=True)"



FROM jeanblanchard/alpine-glibc:3.7
LABEL maintainer "taddeusz@gmail.com"

ENV LD_LIBRARY_PATH /usr/lib:/usr/local/lib:/opt/calibre/lib
ENV PATH $PATH:/opt/calibre/bin

RUN apk update && \
    apk add --no-cache --upgrade \
    bash \
    python \
    tini \
    supervisor \
    qt5-qtbase-x11 \
    libxrender \
    libxcomposite

COPY --from=build /opt/calibre/ /opt/calibre/
ADD /image /
RUN chmod +x /startup.sh && \
    chmod +x /etc/periodic/15min/calibre-import

VOLUME ["/calibre-library"]
VOLUME ["/calibre-import"]
EXPOSE 8080

CMD [ "/startup.sh" ]