# CPU Benchmark Dockerfile
FROM arm64v8/debian:bullseye-slim

# Install stress-ng and curl for HTTP requests
RUN apt-get update && apt-get install -y stress-ng curl

# Copy the benchmark script
COPY benchmark.sh /benchmark.sh

# Give execute permissions to the script
RUN chmod +x /benchmark.sh

# Set the default command to run the benchmark
CMD ["/benchmark.sh"]
