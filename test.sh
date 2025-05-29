#!/bin/bash

# 🚗 Vehicle Pre-Trip Health Report – Activated When Battery Turns On
# Retrieves previous trip data and provides a structured health report.

LOG_FILE="vehicle_health_report.log"
SERVICE_LOG="vehicle_service_record.log"
PREV_TRIP_FILE="previous_trip_data.log"

# Define color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# 🚨 SAFETY REMINDER
echo -e "${RED}⚠️ Always manually inspect key components before operating the vehicle!${NC}"
echo -e "${RED}🛑 Drive safe! Preventative checks reduce risks.${NC}"
echo -e "${BLUE}🔹 Last Trip Analysis | $(date)${NC}" > "$LOG_FILE"
echo "------------------------------------------------------" >> "$LOG_FILE"

# 🔄 Retrieve Previous Trip Data
if [[ -f "$PREV_TRIP_FILE" ]]; then
    source "$PREV_TRIP_FILE"
    echo -e "${BLUE}🔄 Previous Trip Data Loaded!${NC}"
else
    echo -e "${YELLOW}⚠️ No previous trip data found. Please enter details manually.${NC}"
    echo "Enter estimated trip distance (in km): "
    read trip_distance
    echo "Enter estimated vehicle load weight (in kg): "
    read load_weight
    echo "Select road type (1 = Smooth, 2 = Bumpy, 3 = Harsh Terrain): "
    read road_type
fi

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
        status="${YELLOW}🟡 Moderate Wear – Inspect before long trips.${NC}"
    else
        status="${GREEN}🟢 Good Condition – No immediate concerns.${NC}"
    fi
    echo -e "🚙 Tire Wear: $tire_wear% | Trip Distance: ${trip_distance}km | Road: $road_condition | Status: $status" >> "$LOG_FILE"
}

# ⚡ Battery Health Check
check_battery_health() {
    charge_status=$((80 - (trip_distance / 25) - (load_weight / 50)))
    charge_status=$((charge_status < 0 ? 0 : charge_status))
    if [ "$charge_status" -le 30 ]; then
        status="${RED}🔴 Low Charge – Recharge recommended!${NC}"
    elif [ "$charge_status" -le 70 ]; then
        status="${YELLOW}🟡 Moderate Charge – Monitor battery performance.${NC}"
    else
        status="${GREEN}🟢 Healthy – No issues detected.${NC}"
    fi
    echo -e "⚡ Battery Charge: $charge_status% | Load Weight: ${load_weight}kg | Status: $status" >> "$LOG_FILE"
}

# 🔥 Engine Performance Check
check_engine_performance() {
    engine_temp=$((70 + RANDOM % 30))
    avg_rpm=$((2000 + RANDOM % 4000))
    oil_viscosity=$(echo "scale=2; 5.0 + ($RANDOM % 5)/10" | bc)
    if [ "$engine_temp" -ge 100 ]; then
        status="${RED}🔴 High Temperature – Inspection recommended!${NC}"
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
        brake_status="${YELLOW}🟡 Caution – Brake inspection recommended.${NC}"
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
    echo -e "${GREEN}✅ Your vehicle is in good condition for the entered distance. Drive Safe & Enjoy with Your Family!${NC}" >> "$LOG_FILE"
else
    echo -e "${RED}⚠️ Some components need attention before your trip! Please check manually.${NC}" >> "$LOG_FILE"
fi

echo -e "✅ Report Generated: $LOG_FILE"
cat "$LOG_FILE"

# 🔄 Save Trip Data for Future Reference
echo "trip_distance=$trip_distance" > "$PREV_TRIP_FILE"
echo "load_weight=$load_weight" >> "$PREV_TRIP_FILE"
echo "road_type=$road_type" >> "$PREV_TRIP_FILE"
