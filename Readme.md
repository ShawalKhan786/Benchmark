# Docker for Embedded Modular Software

This project aims to streamline and modularize benchmark testing for embedded systems using Docker containers. It leverages Docker's `buildx` and `compose` features to ensure seamless builds and cross-platform compatibility, specifically targeting ARM and x86_64 architectures. The benchmark software has been developed and tested on macOS (ARM-based architecture) and a Debian virtual machine, and it is also ready for testing on NXP boards.

## Table of Contents
- [Overview](#overview)
- [Docker Images](#docker-images)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Building and Running Containers](#building-and-running-containers)
  - [Managing Services](#managing-services)
- [Benchmark Results](#benchmark-results)
  - [Accessing Results via Browser](#accessing-results-via-browser)
  - [Benchmark Table (in progress)](#benchmark-table-in-progress)

## Overview
This project provides a modular approach to benchmarking embedded systems using Docker. It consists of four primary modules:
- **CPU Benchmark**
- **Memory Benchmark**
- **Network Benchmark**
- **Coordinator**

The Docker images for each benchmark module are available on Docker Hub, ensuring ease of deployment across multiple platforms, including ARM-based systems like the NXP board and standard x86-based systems.

The benchmarks were developed in a Debian virtual machine on macOS (Apple M1 with ARM architecture), and have been tested successfully on both environments.

## Docker Images
The following Docker images have been built and are available for use:
- [CPU Benchmark](https://hub.docker.com/repository/docker/shawalkhan786/cpu-benchmark/general)
- [Memory Benchmark](https://hub.docker.com/repository/docker/shawalkhan786/memory-benchmark/general)
- [Network Benchmark](https://hub.docker.com/repository/docker/shawalkhan786/network-benchmark/general)
- [Coordinator](https://hub.docker.com/repository/docker/shawalkhan786/coordinator/general)

These images have been pushed to Docker Hub and can be pulled and used directly for benchmarking tasks.

## Setup Instructions

### Prerequisites
To run this project, you need:
- **Docker** installed on your system.

Make sure Docker is installed on your system and running, with `buildx` properly configured for cross-platform builds.

### Building and Running Containers



 **Build and start services with Docker Compose**:
   - Build and run the containers:
     ```bash
     docker compose up --build
     ```
   - To shut down the containers and remove volumes:
     ```bash
     docker compose down -v
     ```
    

### Managing Services

- **Start the services**:
  ```bash
  docker-compose up -d
After setting up Docker Compose, verify that all services are running:
 ```bash
  docker-compose p
  ```
  You can view the logs of all services in real-time by running:  
   ```bash
   docker-compose logs -f
   ```
Benchmark results will also be available via the browser. Once the services are running, open your browser and go to:

```bash
http://127.0.0.1:8080/results
```
## Note: The table is still under development and more results will be added as the benchmarks complete.