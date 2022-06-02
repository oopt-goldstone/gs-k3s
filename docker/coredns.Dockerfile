FROM golang:bullseye AS builder

RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install quilt build-essential make

RUN --mount=type=bind,source=sm/coredns,target=/root/sm/coredns,rw \
    --mount=type=bind,source=patches/coredns,target=/root/patches \
    --mount=type=bind,source=.git,target=/root/.git \
    --mount=type=tmpfs,target=/root/.pc,rw \
    cd /root && quilt upgrade && quilt push -a && \
    cd /root/sm/coredns && make && cp coredns /

FROM debian:stable-slim AS cert

RUN apt-get update && apt-get -uy upgrade
RUN apt-get -y install ca-certificates && update-ca-certificates

FROM scratch

COPY --from=cert /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]
