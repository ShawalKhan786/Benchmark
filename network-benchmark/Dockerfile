# Network Benchmark Dockerfile
FROM arm64v8/debian:bullseye-slim

# Install iperf3 and curl for HTTP requests
RUN apt-get update && apt-get install -y iperf3 curl

# Copy the client and server scripts
COPY client.sh /client.sh
COPY server.sh /server.sh

# Give execute permissions to the scripts
RUN chmod +x /client.sh /server.sh

# By default, run the server script. This can be overridden in docker-compose.yml.
CMD ["/server.sh"]
