import csv
from flask import Flask, request

app = Flask(__name__)

results = {
    "cpu": {},
    "memory": {},
    "network": {}
}

@app.route('/upload/cpu', methods=['POST'])
def upload_cpu_result():
    # Assuming the POST data contains CPU load percentage
    cpu_load = request.form.get('load')  # You should send 'load' in the POST request
    core_used = request.form.get('core')  # Assuming core type is also sent
    results['cpu'] = {
        "CPU Load (%)": cpu_load,
        "Memory Usage (MB)": '-',
        "Network Throughput (Mbps)": '-',
        "Intra-Container Latency (ms)": '-',
        "Inter-Container Communication Latency (ms)": '-',
        "Core Used": core_used,
        "Duration (s)": 60
    }
    save_results_to_csv()
    return "CPU result received", 200

@app.route('/upload/memory', methods=['POST'])
def upload_memory_result():
    # Assuming the POST data contains memory usage in MB
    memory_usage = request.form.get('memory')  # You should send 'memory' in the POST request
    core_used = request.form.get('core')  # Assuming core type is also sent
    results['memory'] = {
        "CPU Load (%)": '-',
        "Memory Usage (MB)": memory_usage,
        "Network Throughput (Mbps)": '-',
        "Intra-Container Latency (ms)": '-',
        "Inter-Container Communication Latency (ms)": '-',
        "Core Used": core_used,
        "Duration (s)": 60
    }
    save_results_to_csv()
    return "Memory result received", 200

@app.route('/upload/network', methods=['POST'])
def upload_network_result():
    # Assuming the POST data contains network throughput and latency details
    throughput = request.form.get('throughput')  # You should send 'throughput' in the POST request
    intra_latency = request.form.get('intra_latency')  # You should send 'intra_latency' in the POST request
    inter_latency = request.form.get('inter_latency')  # You should send 'inter_latency' in the POST request
    core_used = request.form.get('core')  # Assuming core type is also sent
    results['network'] = {
        "CPU Load (%)": '-',
        "Memory Usage (MB)": '-',
        "Network Throughput (Mbps)": throughput,
        "Intra-Container Latency (ms)": intra_latency,
        "Inter-Container Communication Latency (ms)": inter_latency,
        "Core Used": core_used,
        "Duration (s)": 60
    }
    save_results_to_csv()
    return "Network result received", 200

def save_results_to_csv():
    with open('/results/benchmark_results.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        # Write the header
        writer.writerow([
            'Benchmark Type', 'CPU Load (%)', 'Memory Usage (MB)', 
            'Network Throughput (Mbps)', 'Intra-Container Latency (ms)',
            'Inter-Container Communication Latency (ms)', 'Core Used', 'Duration (s)'
        ])
        # Write CPU results
        if results['cpu']:
            writer.writerow(['CPU Benchmark'] + list(results['cpu'].values()))
        # Write Memory results
        if results['memory']:
            writer.writerow(['Memory Benchmark'] + list(results['memory'].values()))
        # Write Network results
        if results['network']:
            writer.writerow(['Network Benchmark'] + list(results['network'].values()))

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
