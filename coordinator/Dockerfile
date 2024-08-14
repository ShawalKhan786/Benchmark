# Coordinator Dockerfile
FROM arm64v8/debian:bullseye-slim

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Install Flask and Requests
RUN pip3 install flask requests

# Copy the coordinator script
COPY coordinator.py /coordinator.py

# Set the default command to run the coordinator
CMD ["python3", "/coordinator.py"]
