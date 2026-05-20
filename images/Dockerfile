FROM ubuntu:24.04 AS builder

# Install curl and the necessary CA certificates
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

RUN curl -Lo /disk.img https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

FROM scratch

COPY --from=builder /disk.img /disk/disk.img
