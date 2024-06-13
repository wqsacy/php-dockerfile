# Use Alpine as the base image
FROM alpine:latest

# Set environment variables
ENV FRPS_VERSION=0.58.1
ENV FP_MULTIUSER_VERSION=0.2.1

# Install necessary packages
RUN apk add --no-cache bash curl

# Download and extract frps
RUN curl -L -o /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.58.1/frp_0.58.1_linux_amd64.tar.gz && \
    tar -xzf /tmp/frp.tar.gz -C /tmp && \
    mv /tmp/frp_0.58.1_linux_amd64/frps /usr/local/bin/frps && \
    rm -rf /tmp/frp*

# Download and extract fp-multiuser
RUN curl -L -o /tmp/fp-multiuser.tar.gz https://github.com/sakshyam393/fp-multiuser/releases/download/v0.2.1/fp-multiuser_0.2.1_linux_amd64.tar.gz && \
    tar -xzf /tmp/fp-multiuser.tar.gz -C /tmp && \
    mv /tmp/fp-multiuser /usr/local/bin/fp-multiuser && \
    rm -rf /tmp/fp-multiuser*

# Create directories for configuration files and tokens
RUN mkdir -p /etc/frp /etc/frp/tokens

# Expose the necessary ports
EXPOSE 7000 80 7200

# Copy frps configuration file and token file (if provided)
COPY conf/frps.ini /etc/frp/frps.ini
COPY conf/tokens.ini /etc/frp/tokens.ini

# Command to run frps and fp-multiuser
CMD ["sh", "-c", "frps -c /etc/frp/frps.ini & sleep 2 && fp-multiuser -token_file /etc/frp/tokens.ini"]