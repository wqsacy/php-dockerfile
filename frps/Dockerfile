# Use the official Golang image to build the frps binary
FROM golang:latest AS build

# Set environment variables
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Download and install frps and fp-multiuser
RUN go install github.com/fatedier/frp/cmd/frps@latest && \
    go install github.com/sakshyam393/frp-multiuser@latest

# Create a minimal image with the frps binary and the plugin
FROM alpine:latest

# Copy frps binary and fp-multiuser plugin from the build stage
COPY --from=build /go/bin/frps /usr/local/bin/frps
COPY --from=build /go/bin/frp-multiuser /usr/local/bin/frp-multiuser

# Create directories for configuration files and tokens.ini
RUN mkdir -p /etc/frp /etc/frp/tokens.ini

# Expose the necessary ports
EXPOSE 7000 80 7200

# Copy frps configuration file and token file (if provided)
COPY conf/frps.ini /etc/frp/frps.ini
COPY conf/tokens.ini /etc/frp/tokens/tokens.ini

# Command to run frps and fp-multiuser
CMD ["sh", "-c", "frps -c /etc/frp/frps.ini & sleep 2 && frp-multiuser -token_file /etc/frp/tokens/tokens.txt"]