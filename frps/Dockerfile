# Use the official Golang image to build the frps binary
FROM golang:latest AS build

# Set environment variables
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Clone and build frps
RUN git clone https://github.com/fatedier/frp.git && \
    cd frp && \
    go build -o /go/bin/frps ./cmd/frps

# Clone and build fp-multiuser
RUN git clone https://github.com/sakshyam393/frp-multiuser.git && \
    cd frp-multiuser && \
    go build -o /go/bin/frp-multiuser

# Create a minimal image with the frps binary and the plugin
FROM alpine:latest

# Copy frps binary and fp-multiuser plugin from the build stage
COPY --from=build /go/bin/frps /usr/local/bin/frps
COPY --from=build /go/bin/frp-multiuser /usr/local/bin/frp-multiuser

# Install necessary packages for running sh
RUN apk add --no-cache bash

# Create directories for configuration files and tokens
RUN mkdir -p /etc/frp /etc/frp/tokens

# Expose the necessary ports
EXPOSE 7000 80 7200

# Copy frps configuration file and token file (if provided)
COPY conf/frps.ini /etc/frp/frps.ini
COPY conf/tokens /etc/frp/tokens/tokens.txt

# Command to run frps and fp-multiuser
CMD ["sh", "-c", "frps -c /etc/frp/frps.ini & sleep 2 && frp-multiuser -token_file /etc/frp/tokens/tokens.txt"]