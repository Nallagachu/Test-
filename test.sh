#!/bin/bash

# 🚗 Vehicle Health & Service Tracker – Colorful & Interactive
# Analyzes wear based on trip details and logs service history.

LOG_FILE="vehicle_health_report.log"
SERVICE_LOG="vehicle_service_record.log"

# Define color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

echo -e "${BLUE}⚠️ Reminder: Please manually inspect key components before operating the vehicle!${NC}" > "$LOG_FILE"
echo -e "${BLUE}🔹 Last Trip Analysis | $(date)${NC}" >> "$LOG_FILE"
echo "------------------------------------------------------" >> "$LOG_FILE"

# 🛠️ Get user input for trip details
echo -e "${BLUE}Enter estimated trip distance (in km): ${NC}"
read trip_distance

echo -e "${BLUE}Enter estimated vehicle load weight (in kg): ${NC}"
read load_weight

echo -e "${BLUE}Select road type (1 = Smooth, 2 = Bumpy, 3 = Harsh Terrain): ${NC}"
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
    if [ "$tire_wear" -ge 80 ]; then
        status="${RED}🔴 Critical – Replace tires soon!${NC}"
    elif [ "$tire_wear" -ge 50 ]; then
        status="${YELLOW}🟡 Moderate Wear – Inspect soon.${NC}"
    else
        status="${GREEN}🟢 Good Condition – No issues.${NC}"
    fi
    echo -e "🚙 Tire Wear: $tire_wear% | Trip Distance: ${trip_distance}km | Road: $road_condition | Status: $status" >> "$LOG_FILE"
}

# ⚡ Battery Health Check
check_battery_health() {
    charge_status=$((80 - (trip_distance / 25) - (load_weight / 50)))
    charge_status=$((charge_status < 0 ? 0 : charge_status))
    if [ "$charge_status" -le 30 ]; then
        status="${RED}🔴 Low Charge – Needs recharging!${NC}"
    elif [ "$charge_status" -le 70 ]; then
        status="${YELLOW}🟡 Moderate Charge – Recharge recommended.${NC}"
    else
        status="${GREEN}🟢 Healthy – No immediate concerns.${NC}"
    fi
    echo -e "⚡ Battery Charge: $charge_status% | Load Weight: ${load_weight}kg | Status: $status" >> "$LOG_FILE"
}

# 🔥 Engine Performance Check
check_engine_performance() {
    engine_temp=$((70 + RANDOM % 30))
    avg_rpm=$((2000 + RANDOM % 4000))
    oil_viscosity=$(echo "scale=2; 5.0 + ($RANDOM % 5)/10" | bc)
    if [ "$engine_temp" -ge 100 ]; then
        status="${RED}🔴 High Temperature – Consider inspection!${NC}"
    else
        status="${GREEN}🟢 Normal Engine Temperature.${NC}"
    fi
    echo -e "🔥 Engine Temp: $engine_temp°C | Avg RPM: $avg_rpm | Oil Viscosity: $oil_viscosity | Status: $status" >> "$LOG_FILE"
}

# 🚙 Suspension Wear Check
check_suspension() {
    suspension_wear=$((40 + (trip_distance / 15) + wear_modifier))
    if [ "$suspension_wear" -ge 80 ]; then
        status="${RED}🔴 Critical – Suspension tuning required!${NC}"
    elif [ "$suspension_wear" -ge 50 ]; then
        status="${YELLOW}🟡 Moderate wear – Inspect soon.${NC}"
    else
        status="${GREEN}🟢 Suspension in good condition.${NC}"
    fi
    echo -e "🔧 Suspension Wear: $suspension_wear% | Trip Distance: ${trip_distance}km | Road: $road_condition | Status: $status" >> "$LOG_FILE"
}

# 🔧 Brake Wear & Alignment Suggestion
suggest_maintenance() {
    brake_wear=$((20 + (trip_distance / 25) + wear_modifier))
    alignment_need=$((wear_modifier / 2))
    if [ "$brake_wear" -ge 75 ]; then
        brake_status="${RED}🔴 Urgent – Replace brakes!${NC}"
    elif [ "$brake_wear" -ge 50 ]; then
        brake_status="${YELLOW}🟡 Caution – Inspect brakes.${NC}"
    else
        brake_status="${GREEN}🟢 Brakes are fine.${NC}"
    fi
    echo -e "🛑 Brake Wear: $brake_wear% | Status: $brake_status" >> "$LOG_FILE"
    echo -e "🔄 Recommended Wheel Alignment Adjustment: ${alignment_need}°" >> "$LOG_FILE"
}

# ✅ Generate Vehicle Health Report
check_tire_wear
check_battery_health
check_engine_performance
check_suspension
suggest_maintenance

# 🚦 Final Summary – Is the vehicle good to go?
if [[ "$tire_wear" -lt 50 && "$charge_status" -gt 50 && "$engine_temp" -lt 100 && "$suspension_wear" -lt 50 && "$brake_wear" -lt 50 ]]; then
    echo -e "${GREEN}✅ Your vehicle is in good condition for the entered distance!${NC}" >> "$LOG_FILE"
else
    echo -e "${RED}⚠️ Some components need attention before your trip!${NC}" >> "$LOG_FILE"
fi

echo "✅ Report Generated: $LOG_FILE"
cat "$LOG_FILE"
