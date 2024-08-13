# Network Benchmark Dockerfile
FROM arm64v8/debian:bullseye-slim

# Install iperf3 for network benchmarking
RUN apt-get update && apt-get install -y iperf3

# Copy the server and client scripts
COPY server.sh /server.sh
COPY client.sh /client.sh

# Give execute permissions to the scripts
RUN chmod +x /server.sh /client.sh

# Default command to run the server; override in docker-compose.yml for client
CMD ["/server.sh"]
