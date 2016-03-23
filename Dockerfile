FROM alpine:3.3

ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1

RUN mkdir -p "$GOPATH/src/" "$GOPATH/bin" && chmod -R 777 "$GOPATH" && \
    mkdir -p /go/src/github.com/kelseyhightower/confd

ENV CONFD_VERSION=0.11.0

RUN echo "http://dl-2.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories && \
    apk add --update go bash git netcat-openbsd && \
    git clone https://github.com/kelseyhightower/confd.git /go/src/github.com/kelseyhightower/confd && \
    cd /go/src/github.com/kelseyhightower/confd && \
    mkdir -p bin && \
    go build -o bin/confd . && \
    mv bin/confd /bin/ && \
    chmod +x /bin/confd && \
    apk del go git && \
    rm -rf /var/cache/apk/* /go

RUN mkdir -p /etc/confd/templates
RUN mkdir -p /etc/confd/conf.d

COPY confd/nginx.toml /etc/confd/conf.d/
COPY confd/nginx.tmpl /etc/confd/templates/

ENTRYPOINT ["confd"]