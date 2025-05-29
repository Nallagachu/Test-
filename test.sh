#!/bin/bash

# 🚘 Vehicle Health & Service Tracker
# Analyzes wear based on trip details and logs service history.

LOG_FILE="vehicle_health_report.log"
SERVICE_LOG="vehicle_service_record.log"

echo "⚠️ Reminder: Please manually inspect key components before operating the vehicle!" > "$LOG_FILE"
echo "🔹 Last Trip Analysis | $(date)" >> "$LOG_FILE"
echo "------------------------------------------------------" >> "$LOG_FILE"

# 🛠️ Get user input for trip details
echo "Enter estimated trip distance (in km): "
read trip_distance

echo "Enter estimated vehicle load weight (in kg): "
read load_weight

echo "Select road type (1 = Smooth, 2 = Bumpy, 3 = Harsh Terrain): "
read road_type

# Define road condition modifier
case $road_type in
    1) road_condition="Smooth Road"; wear_modifier=-10 ;;
    2) road_condition="Bumpy Surface"; wear_modifier=+10 ;;
    3) road_condition="Harsh Terrain"; wear_modifier=+20 ;;
    *) road_condition="Unknown"; wear_modifier=0 ;;
esac

# 🚗 Tire Wear Analysis
check_tire_wear() {
    tire_wear=$((30 + (trip_distance / 20) + (wear_modifier / 2)))
    status=$( [[ "$tire_wear" -ge 80 ]] && echo "🔴 Critical – Replace tires soon!" || [[ "$tire_wear" -ge 50 ]] && echo "🟡 Moderate Wear – Inspect soon." || echo "🟢 Good Condition – No issues.")
    echo "Tire Wear: $tire_wear% | Trip Distance: ${trip_distance}km | Road: $road_condition | Status: $status" >> "$LOG_FILE"
}

# ⚡ Battery Health Check
check_battery_health() {
    charge_status=$((80 - (trip_distance / 25) - (load_weight / 50)))
    charge_status=$((charge_status < 0 ? 0 : charge_status))
    status=$( [[ "$charge_status" -le 30 ]] && echo "🔴 Low Charge – Needs recharging!" || [[ "$charge_status" -le 70 ]] && echo "🟡 Moderate Charge – Recharge recommended." || echo "🟢 Healthy – No immediate concerns.")
    echo "Battery Charge: $charge_status% | Load Weight: ${load_weight}kg | Status: $status" >> "$LOG_FILE"
}

# 🔥 Engine Performance Check
check_engine_performance() {
    engine_temp=$((70 + RANDOM % 30))
    avg_rpm=$((2000 + RANDOM % 4000))
    oil_viscosity=$(echo "scale=2; 5.0 + ($RANDOM % 5)/10" | bc)
    status=$( [[ "$engine_temp" -ge 100 ]] && echo "🔴 High Temperature – Consider inspection!" || echo "🟢 Normal Engine Temperature.")
    echo "Engine Temp: $engine_temp°C | Avg RPM: $avg_rpm | Oil Viscosity: $oil_viscosity | Status: $status" >> "$LOG_FILE"
}

# 🚙 Suspension Wear Check
check_suspension() {
    suspension_wear=$((40 + (trip_distance / 15) + wear_modifier))
    status=$( [[ "$suspension_wear" -ge 80 ]] && echo "🔴 Critical – Suspension tuning required!" || [[ "$suspension_wear" -ge 50 ]] && echo "🟡 Moderate wear – Inspect soon." || echo "🟢 Suspension in good condition.")
    echo "Suspension Wear: $suspension_wear% | Trip Distance: ${trip_distance}km | Road: $road_condition | Status: $status" >> "$LOG_FILE"
}

# 🔧 Brake Wear & Alignment Suggestion
suggest_maintenance() {
    brake_wear=$((20 + (trip_distance / 25) + wear_modifier))
    alignment_need=$((wear_modifier / 2))
    brake_status=$( [[ "$brake_wear" -ge 75 ]] && echo "🔴 Urgent – Replace brakes!" || [[ "$brake_wear" -ge 50 ]] && echo "🟡 Caution – Inspect brakes." || echo "🟢 Brakes are fine.")
    echo "Brake Wear: $brake_wear% | Status: $brake_status" >> "$LOG_FILE"
    echo "Recommended Wheel Alignment Adjustment: ${alignment_need}°" >> "$LOG_FILE"
}

# ✅ Generate Vehicle Health Report
check_tire_wear
check_battery_health
check_engine_performance
check_suspension
suggest_maintenance

echo "✅ Report Generated: $LOG_FILE"
cat "$LOG_FILE"

# 📌 Service Record Logging
log_service() {
    echo "Would you like to log a service entry? (y/n)"
    read log_choice
    if [[ "$log_choice" == "y" ]]; then
        echo "Enter service date (YYYY-MM-DD): "
        read service_date
        echo "Enter mileage at service: "
        read mileage
        echo "Enter components checked/replaced (comma-separated): "
        read components
        echo "Enter next recommended service date (YYYY-MM-DD): "
        read next_service
        echo "🔹 Service Log Entry" >> "$SERVICE_LOG"
        echo "Service Date: $service_date" >> "$SERVICE_LOG"
        echo "Mileage: $mileage km" >> "$SERVICE_LOG"
        echo "Components Serviced: $components" >> "$SERVICE_LOG"
        echo "Next Service Due: $next_service" >> "$SERVICE_LOG"
        echo "------------------------------------------------------" >> "$SERVICE_LOG"
        echo "✅ Service record updated!"
        cat "$SERVICE_LOG"
    fi
}

log_service
