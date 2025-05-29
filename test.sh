#!/bin/bash

# 🚗 Vehicle Health Report Generator – Simulated version
# Collects sensor data and generates a detailed health summary

LOG_FILE="vehicle_health_report.log"

# Function to simulate tire wear calculation
check_tire_wear() {
    wear_level=$((RANDOM % 100))
    if [ "$wear_level" -ge 80 ]; then
        status="🔴 Critical – Replace tires soon!"
    elif [ "$wear_level" -ge 50 ]; then
        status="🟡 Warning – Moderate wear detected."
    else
        status="🟢 Good – Tires are in optimal condition."
    fi
    echo "Tire Wear: $wear_level% | Status: $status" >> "$LOG_FILE"
}

# Function to simulate battery health check
check_battery_health() {
    voltage=$(echo "scale=2; 12.0 + ($RANDOM % 20)/10" | bc)
    charge_status=$((RANDOM % 100))
    
    if [ "$charge_status" -le 30 ]; then
        status="🔴 Low Charge – Battery needs inspection!"
    elif [ "$charge_status" -le 70 ]; then
        status="🟡 Moderate Charge – Keep an eye on performance."
    else
        status="🟢 Healthy – Battery is performing well."
    fi
    echo "Battery Voltage: $voltage V | Charge: $charge_status% | Status: $status" >> "$LOG_FILE"
}

# Function to simulate engine performance monitoring
check_engine_performance() {
    engine_temp=$((70 + RANDOM % 30))
    oil_viscosity=$(echo "scale=2; 5.0 + ($RANDOM % 5)/10" | bc)

    if [ "$engine_temp" -ge 100 ]; then
        status="🔴 High Temperature – Possible overheating!"
    else
        status="🟢 Normal Engine Temperature."
    fi
    echo "Engine Temp: $engine_temp°C | Oil Viscosity: $oil_viscosity | Status: $status" >> "$LOG_FILE"
}

# Function to simulate suspension fatigue analysis
check_suspension() {
    suspension_wear=$((RANDOM % 100))
    if [ "$suspension_wear" -ge 80 ]; then
        status="🔴 Critical – Suspension needs servicing!"
    elif [ "$suspension_wear" -ge 50 ]; then
        status="🟡 Moderate wear detected."
    else
        status="🟢 Suspension in good condition."
    fi
    echo "Suspension Wear: $suspension_wear% | Status: $status" >> "$LOG_FILE"
}

# Generate Report
echo "🚘 Vehicle Health Report – $(date)" > "$LOG_FILE"
echo "--------------------------------------" >> "$LOG_FILE"

check_tire_wear
check_battery_health
check_engine_performance
check_suspension

echo "✅ Report Generated: $LOG_FILE"
cat "$LOG_FILE"
