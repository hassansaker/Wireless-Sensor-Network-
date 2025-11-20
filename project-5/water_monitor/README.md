# Project 5 - Water Monitoring WSN

Project 5 contains a CupCarbon 7.0 scenario (`water_monitor.cup`) that models a multi-hop ZigBee water-level monitoring network for dam and flood safety. Forty-plus field sensors (S1-S41) read synthetic hydro traces, classify every sample, and forward summarized frames through hop routers to the sink node S100. Natural event nodes feed the water-level values so you can replay normal, flood, or dam-break profiles without touching the scripts.

## Scenario Highlights
- **Adaptive sensing:** `scripts/SensNode.csc` increases the sampling rate as soon as rising levels push the system into WARNING/CRITICAL/EMERGENCY states and throttles transmissions when the river is calm.
- **Threshold-triggered traffic:** Each sensor only sends when the difference from the previous accepted level exceeds 0.2 m, keeping the channel free until a meaningful change occurs.
- **Deterministic routing:** `scripts/hop_*.csc` files are minimalist routers that stamp their ID and forward frames toward the base station that runs `scripts/SinkNode.csc`.
- **Synthetic hydrology:** `config/nodes/gas_*` nodes subscribe to the `natevents/*.evt` files (Normal, Flood, and Dam cases) so you can stress-test the network without reconfiguring CupCarbon.

## Sensor & Traffic Logic

| Trend label | Water level range (m) | Reporting interval (ms) | Notes |
| ----------- | -------------------- | ----------------------- | ----- |
| NORMAL      | <= 3.5               | 900000 (15 min)         | Lowest duty cycle to save energy. |
| WARNING     | 3.5 - 4.0            | 600000 (10 min)         | Begins proactive sampling of rising water. |
| CRITICAL    | 4.0 - 5.5            | 300000 (5 min)          | Rapid trend confirmation. |
| EMERGENCY   | > 5.5                | 60000 (1 min)           | Near real-time reporting for evacuation workflows. |

- All ranges and intervals live at the top of `scripts/SensNode.csc`; adjust them there if your project targets another river.
- Sink logic in `scripts/SinkNode.csc` keeps running counts per state and prints a human-readable summary in `results/SINK_100.txt` every 100 packets.
- Router scripts (hop_11...hop_41) just receive, rewrap, and `send forward <next-id>`; edit them if you want to try alternative topologies.

## Repository Layout

```text
project-5/water_monitor/
|-- water_monitor.cup              # CupCarbon scenario file (center point and map settings)
|-- config/
|   |-- simulationParams.cfg       # Simulation speed, MAC, ACK, and logging knobs
|   |-- nodes/                     # Node geolocation and script binding per ID
|   `-- sensor_radios/             # ZigBee radio power and PHY configuration
|-- natevents/                     # Normal, flood, and dam water-level traces (*.evt)
|-- scripts/                       # Sensor, sink, and relay behaviors in CSC
|-- logs/log.txt                   # CupCarbon console log (timeline and ATGET output)
`-- results/
    |-- SINK_100.txt               # Rolling summary from SinkNode
    `-- wisen_simulation.csv       # Per-node energy log exported by WiSen
```

## Prerequisites

- CupCarbon Klines 7.0 (or newer with CSC compatibility).
- Java 11 or later (required by CupCarbon).
- A machine that can read/write this repository; no extra Python or MATLAB dependencies are necessary.

## Running the Simulation

1. Install and start CupCarbon.
2. Load the scenario: `File -> Open` and select `project-5/water_monitor/water_monitor.cup`.
3. Load the saved parameters (optional but recommended): `Simulation -> Parameters -> Load` and point to `config/simulationParams.cfg` so the runtime matches the version tracked here.
4. Pick the desired natural event trace: the default nodes reference `Normal_level.evt`. To replay `flood_level.evt` or `dam_level.evt`, edit the `natural_event_file_name` entry inside the relevant `config/nodes/gas_*` file before launching CupCarbon or via the node inspector.
5. Run wSim: click the green "WSim" button. Watch the live console (`display_print_messages` is enabled) to see state transitions and hop forwarding.
6. Stop the run once you have enough readings. CupCarbon writes `logs/log.txt` and refreshes the `results` folder automatically.

## Inspecting and Exporting Results

- `logs/log.txt` captures the chronological trace (ATGET IDs, packet receipts, and sensor prints).
- `results/SINK_100.txt` provides the rolling counts of NORMAL/WARNING/CRITICAL/EMERGENCY packets every 100 transmissions.
- `results/wisen_simulation.csv` logs residual energy (%) for the sink and every sensor at the sampling interval you configured.
- The CupCarbon UI also shows per-node charts; export them from `Tools -> Graphs` if you need additional plots for reporting.

## Customization Ideas

- **Threshold tuning:** edit the constants near the top of `scripts/SensNode.csc` to match another body of water or to evaluate different alert policies.
- **Network layout:** change the latitude/longitude/radius entries in `config/nodes/*` or add new nodes (remember to supply a matching radio profile under `config/sensor_radios/`).
- **Routing experiments:** modify `scripts/hop_*.csc` to try redundancy, buffering, or priority queues; all router scripts are intentionally tiny starting points.
- **MAC/PHY controls:** play with `mac_layer`, `ack*`, and `radio_*` values inside `config/simulationParams.cfg` and `config/sensor_radios/` to study reliability versus energy trade-offs.

---

Feel free to adapt the README if you add new traces, sensors, or post-processing notebooks.
