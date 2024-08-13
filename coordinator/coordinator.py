import os
import requests
import time

# Example of a simple coordinator script
def run_benchmark():
    cpu_response = requests.get('http://cpu-benchmark:8080/start')
    memory_response = requests.get('http://memory-benchmark:8080/start')
    network_response = requests.get('http://network-client:8080/start')

    print("CPU Benchmark Result:", cpu_response.text)
    print("Memory Benchmark Result:", memory_response.text)
    print("Network Benchmark Result:", network_response.text)

if __name__ == "__main__":
    run_benchmark()
