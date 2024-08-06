

# Use Debian as the base image
FROM debian:latest

# Install socat
RUN apt-get update && \
    apt-get install -y socat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a script to run socat with desired parameters
RUN echo '#!/bin/sh\n\
socat TCP-LISTEN:$LOCAL_PORT,fork TCP:$REMOTE_IP:$REMOTE_PORT\n\
' > /usr/local/bin/start-socat.sh && \
    chmod +x /usr/local/bin/start-socat.sh

# Set environment variables
ENV LOCAL_PORT=7860
ENV REMOTE_IP=115.244.41.198
ENV REMOTE_PORT=443

EXPOSE 7860

# Ensure the script exists and is executable
RUN ls -l /usr/local/bin/start-socat.sh

# Run socat when the container starts
ENTRYPOINT ["/usr/local/bin/start-socat.sh"]

