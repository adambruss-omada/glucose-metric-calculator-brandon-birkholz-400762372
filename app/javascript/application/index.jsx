import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom/client";

const App = () => {
  const [metrics, setMetrics] = useState(null);
  const [timeFrame, setTimeFrame] = useState("week");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // Hardcoded JWT token for API authentication, since auth is out of scope for this project
  const token =
    "eyJhbGciOiJIUzI1NiJ9.eyJtZW1iZXJfaWQiOjJ9.ehijRggtiSGqm4GPyf3QdZg8jyQfWAX5Xtjzeix9nyY";

  useEffect(() => {
    const fetchMetrics = async () => {
      setLoading(true);
      setError(null);
      try {
        const response = await fetch(`/api/v1/glucose_metrics/${timeFrame}`, {
          headers: {
            Authorization: `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        });

        if (!response.ok) {
          throw new Error("Failed to fetch metrics");
        }

        const data = await response.json();
        setMetrics(data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchMetrics();
  }, [timeFrame]);

  return (
    <>
      <div>
        <h1>Glucose Metrics Calculator</h1>
      </div>
      <div>
        <h2>Glucose Metrics</h2>
        <div className="time-frame-selector">
          <label htmlFor="timeFrame">Time Frame: </label>
          <select
            id="timeFrame"
            value={timeFrame}
            onChange={(e) => setTimeFrame(e.target.value)}
          >
            <option value="week">Last 7 Days</option>
            <option value="month">Current Month</option>
          </select>
        </div>

        {loading && <p>Loading metrics...</p>}
        {error && <p className="error">Error: {error}</p>}
        {metrics && !loading && !error && (
          <div className="metrics">
            <p>Average Glucose: {metrics.average_glucose} mg/dL</p>
            <p>Time Above Range: {metrics.time_above_range}%</p>
            <p>Time Below Range: {metrics.time_below_range}%</p>
          </div>
        )}
      </div>
    </>
  );
};

document.addEventListener("DOMContentLoaded", () => {
  const root = ReactDOM.createRoot(document.getElementById("root"));
  root.render(<App />);
});
