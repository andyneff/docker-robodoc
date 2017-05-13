FROM alpine:3.5 as build_stage
# FROM debian:8 as build_stage
LABEL maintainer="Andrew Neff <andrew.neff@visionsystemsinc.com>"

RUN apk add --no-cache automake make gcc curl ca-certificates autoconf libc-dev

# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#       automake make gcc curl ca-certificates autoconf libc6-dev

ENV ROBODOC_VERSION=416987af91a1064d2281f77cf71d1b08256ec981
RUN curl -LO https://github.com/gumpu/ROBODoc/archive/${ROBODOC_VERSION}/ROBODoc.tar.gz && \
    tar zxf ROBODoc.tar.gz
RUN cd ROBODoc-${ROBODOC_VERSION} && \
    sed -i 's|sys/unistd.h|unistd.h|' Source/troff_generator.c && \
    sh do.sh && \
    make install

FROM alpine:3.5

COPY --from=build_stage /usr/local/bin/robodoc /usr/bin/

ENTRYPOINT ["robodoc", "--src", "/src", "--doc", "/doc"]

CMD ["--help"]