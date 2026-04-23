# Stage 1: Create the bootable disk image
FROM ubuntu:22.04 AS builder

# Install curl and the necessary CA certificates
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Download a cloud image to use as a base
RUN curl -Lo /disk.img https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img

# Stage 2: Create the final "carrier" container
FROM scratch

# Copy the disk image from the builder stage into the final container.
COPY --from=builder /disk.img /disk/disk.img
