import csv
from flask import Flask, request, render_template_string

app = Flask(__name__)

results = {
    "cpu": None,
    "memory": None,
    "network": None
}

@app.route('/upload/<benchmark_type>', methods=['POST'])
def upload_result(benchmark_type):
    if benchmark_type in results:
        # Store the result
        results[benchmark_type] = request.data.decode('utf-8')
        # Log the result to the console for debugging
        print(f"Received result for {benchmark_type}: {results[benchmark_type]}")
        # Save results to the CSV file
        save_results_to_csv(results)
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
                <th>Result</th>
            </tr>
            {% for key, value in results.items() %}
            <tr>
                <td>{{ key }}</td>
                <td>{{ value }}</td>
            </tr>
            {% endfor %}
        </table>
    ''', results=results)

def save_results_to_csv(results):
    # Log the saving process for debugging
    print("Saving results to CSV:")
    for key, value in results.items():
        print(f"{key}: {value}")
    # Write the results to the CSV file
    with open('/results/benchmark_results.csv', mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Benchmark Type', 'Result'])
        for key, value in results.items():
            writer.writerow([key, value])
    print("Results saved to /results/benchmark_results.csv")

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
