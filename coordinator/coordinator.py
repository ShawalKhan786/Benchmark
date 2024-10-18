import csv
from flask import Flask, request, render_template_string
import pandas as pd
app = Flask(__name__)

# Structured results with placeholders for different sections
results = {
    "cpu": {"load": None, "time": None, "ops": None},
    "memory": {"usage": None, "time": None},
    "network": {"throughput": None, "latency": None, "retransmissions": None}
}

@app.route('/upload/<benchmark_type>', methods=['POST'])
def upload_result(benchmark_type):
    if benchmark_type in results:
        # Parse and store the result
        parsed_data = parse_result(benchmark_type, request.data.decode('utf-8'))
        results[benchmark_type].update(parsed_data)
        # Log the result to the console for debugging
        print(f"Received and parsed result for {benchmark_type}: {parsed_data}")
        # Save results to the CSV file
        #save_results_to_csv(results)
        return "Result received", 200
    return "Invalid benchmark type", 400

@app.route('/results', methods=['GET'])
def get_results():
    # Render the results as an HTML page
    return render_template_string('''
        <h1>Benchmark Results</h1>
        <table border="1">
            <tr>
                <th>Benchmark Type</th>
                <th>CPU Load (%)/Usage</th>
                <th>Memory Usage (MB)</th>
                <th>Network Throughput (Mbps)</th>
                <th>Duration (s)</th>
                <th>Execution Time (s)</th>
                <th>Communication Time Between Containers (ms)</th>
                <th>Memory Usage Over Time (Trend)</th>
                <th>Latency (ms)</th>
                <th>Notes</th>
                                  
                    
            <tr>
                <td>CPU Benchmark</td>
                <td>{{ results.cpu.load }}</td>
                <td>-</td>
                <td>-</td>
                <td>{{ results.cpu.duration }}</td>
                <td>{{ results.cpu.time }}</td>
                <td>{{ results.cpu.communication_time }} </td>
                <td>-</td>
            </tr>
            <tr>
                <td>Memory Benchmark</td>
                <td>-</td>
                <td>{{ results.memory.memory_load }}</td>
                <td>-</td>
                <td>{{ results.memory.duration }}</td>
                <td>{{ results.memory.time }}</td>
                <td>-</td>
                <td>{{ results.memory.communication_time }}</td>
            </tr>
            <tr>
                <td>Network Benchmark</td>
                <td>-</td>
                <td>-</td>
                <td>{{ results.network.throughput }}</td>
               
                <td>{{ results.network.duration }}</td>
                <td>{{ results.network.time }}s</td> 
                <td>-</td>
                <td>{{ results.network.communication_time }}</td>                  
                <td>{{ results.network.latency }} ms</td>
                
                                  
            </tr>
        </table>
    ''', results=results)

def parse_result(benchmark_type, result):
    # This function parses the result based on the benchmark type
    parsed_data = {}
    lines = result.splitlines()

    if benchmark_type == "cpu":
        # Extract CPU load
        parsed_data["load"] = next((line.split(":")[-1].strip() for line in lines if "dispatching hogs" in line), "N/A")
        
        # Extract execution time (real time)
        parsed_data["time"] = next((line.split("completed in")[-1].split()[0].strip() for line in lines if "successful run completed" in line), "N/A")
        parsed_data["communication_time"] = next((line.split(":")[-1].strip() for line in lines if "Communication Time Between Containers" in line), "N/A")
        parsed_data["duration"] = next((line.split("Duration:")[-1].strip() for line in lines if "Duration:" in line), "N/A")
    elif benchmark_type == "memory":
        # Extract "Memory Load" value from the log
        parsed_data["memory_load"] = next((line.split("Memory Load:")[-1].strip().split()[0][:-1] for line in lines if "Memory Load" in line), "N/A")
        parsed_data["duration"] = next((line.split("Duration:")[-1].strip() for line in lines if "Duration:" in line), "N/A")
        parsed_data["time"] = next((line.split("completed in")[-1].split()[0].strip() for line in lines if "successful run completed" in line), "N/A")
        parsed_data["communication_time"] = next((line.split(":")[-1].strip() for line in lines if "Communication Time Memory Containers" in line), "N/A")
        
    elif benchmark_type == "network":
        parsed_data["throughput"] = next(
            (line.split()[6] + " " + line.split()[7] for line in lines if "sec" in line and ("Mbits/sec" in line or "Gbits/sec" in line)), 
            "N/A"
        )
        parsed_data["latency"] = next(
            (line.split("Extracted latency:")[-1].strip() for line in lines if "Extracted latency" in line),
            "N/A"
        )
        parsed_data["retransmissions"] = next((line.split("Retr")[1].strip() for line in lines if "Retr" in line), "N/A")
        parsed_data["duration"] = next((line.split("Duration:")[-1].strip() for line in lines if "Duration:" in line), "N/A")
        parsed_data["time"] = next((line.split()[2].split('-')[1] for line in lines if "sec" in line and "receiver" in line), "N/A")
        parsed_data["communication_time"] = next((line.split(":")[-1].strip() for line in lines if "Communication Time" in line), "N/A")
    return parsed_data


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)

