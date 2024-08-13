# Coordinator Dockerfile
FROM arm64v8/debian:bullseye-slim

# Install Python for the coordinator script
RUN apt-get update && apt-get install -y python3 python3-pip

# Copy requirements and install them
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

# Copy the coordinator script
COPY coordinator.py /coordinator.py

# Set the default command to run the coordinator
CMD ["python3", "/coordinator.py"]
