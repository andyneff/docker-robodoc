FROM alpine:3.5 as build_stage
# FROM debian:8 as build_stage
LABEL maintainer="Andrew Neff <andrew.neff@visionsystemsinc.com>"

#SHELL ["sh", "-euc"]
SHELL ["sh", "-xveuc"]

RUN apk add --no-cache automake make gcc curl ca-certificates autoconf libc-dev \
                       dpkg gnupg openssl

ENV ROBODOC_VERSION=416987af91a1064d2281f77cf71d1b08256ec981
RUN curl -LO https://github.com/gumpu/ROBODoc/archive/${ROBODOC_VERSION}/ROBODoc.tar.gz; \
    tar zxf ROBODoc.tar.gz
RUN cd ROBODoc-${ROBODOC_VERSION}; \
    sed -i 's|sys/unistd.h|unistd.h|' Source/troff_generator.c; \
    sh do.sh; \
    make install

ENV GOSU_VERSION 1.10
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    curl -Lo /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    curl -Lo /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    chmod +x /usr/local/bin/gosu; \
    gosu nobody true

FROM alpine:3.5

COPY --from=build_stage /usr/local/bin/robodoc /usr/bin/
COPY --from=build_stage /usr/local/bin/gosu /usr/local/bin/

ENV DOCKER_UID=1000 DOCKER_GID=1000

ADD robodoc.sh /
RUN chmod 755 /robodoc.sh

ENTRYPOINT ["/robodoc.sh"]

CMD ["--help"]