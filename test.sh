#!/bin/bash

# 🚗 Vehicle Health & Service Tracker – Colorful & Interactive
# Analyzes wear based on trip details and logs service history.

HEALTH_REPORT_FILE="vehicle_health_report.log"
SERVICE_LOG_FILE="vehicle_service_record.log"

# Define color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# --- Utility Functions ---

# Function to check for required commands
check_dependencies() {
    if ! command -v bc &> /dev/null; then
        printf "${RED}Error: 'bc' command is not installed. It's required for some calculations.${NC}\n"
        printf "${YELLOW}Please install 'bc' (e.g., 'sudo apt-get install bc' or 'sudo yum install bc') and try again.${NC}\n"
        exit 1
    fi
}

# Function to get a positive integer input
get_positive_integer_input() {
    local prompt="$1"
    local var_name="$2"
    local input_value
    while true; do
        printf "%s" "$prompt"
        read input_value
        if [[ "$input_value" =~ ^[1-9][0-9]*$ ]] || [[ "$input_value" == "0" ]]; then
            eval "$var_name=$input_value"
            break
        else
            printf "${RED}Invalid input. Please enter a non-negative integer.${NC}\n"
        fi
    done
}

# Function to get a choice from a list
get_choice_input() {
    local prompt="$1"
    local var_name="$2"
    local max_choice="$3"
    local input_value
    while true; do
        printf "%s" "$prompt"
        read input_value
        if [[ "$input_value" =~ ^[1-9][0-9]*$ ]] && [ "$input_value" -ge 1 ] && [ "$input_value" -le "$max_choice" ]; then
            eval "$var_name=$input_value"
            break
        else
            printf "${RED}Invalid choice. Please enter a number between 1 and $max_choice.${NC}\n"
        fi
    done
}

# --- Logging Initialisation ---
initialize_logs() {
    touch "$HEALTH_REPORT_FILE"
    if [ ! -f "$SERVICE_LOG_FILE" ]; then
        printf "${BLUE}🛠️ Vehicle Service Record - Created $(date)${NC}\n" > "$SERVICE_LOG_FILE"
        printf "------------------------------------------------------\n" >> "$SERVICE_LOG_FILE"
    fi
}

# --- Health Check Functions ---
trip_distance=0
load_weight=0
road_type_choice=0
road_condition="Unknown"
wear_modifier=0

# Values for final summary
tire_wear_val=0
battery_charge_val=0
engine_temp_val=0
suspension_wear_val=0
brake_wear_val=0


get_trip_details() {
    printf "${CYAN}--- Enter Trip Details ---${NC}\n"
    get_positive_integer_input "${BLUE}Enter estimated trip distance (in km): ${NC}" trip_distance
    get_positive_integer_input "${BLUE}Enter estimated vehicle load weight (in kg): ${NC}" load_weight
    get_choice_input "${BLUE}Select road type (1 = Smooth, 2 = Bumpy, 3 = Harsh Terrain): ${NC}" road_type_choice 3

    case $road_type_choice in
        1) road_condition="Smooth Road"; wear_modifier=-10 ;;
        2) road_condition="Bumpy Surface"; wear_modifier=10 ;; # Increased modifier slightly
        3) road_condition="Harsh Terrain"; wear_modifier=25 ;; # Increased modifier slightly
        *) road_condition="Unknown"; wear_modifier=0 ;; # Should not happen due to validation
    esac
}

check_tire_wear() {
    local status
    # Base wear + distance factor + road factor
    tire_wear_val=$((20 + (trip_distance / 25) + (wear_modifier / 2) + (load_weight / 100) ))
    if (( tire_wear_val < 0 )); then tire_wear_val=0; fi
    if (( tire_wear_val > 100 )); then tire_wear_val=100; fi

    if [ "$tire_wear_val" -ge 75 ]; then
        status="${RED}🔴 Critical – Replace tires soon!${NC}"
    elif [ "$tire_wear_val" -ge 50 ]; then
        status="${YELLOW}🟡 Moderate Wear – Inspect soon.${NC}"
    else
        status="${GREEN}🟢 Good Condition.${NC}"
    fi
    printf "🚙 Tire Wear: %s%% | Trip: %skm | Road: %s | Load: %skg | Status: %s\n" \
        "$tire_wear_val" "$trip_distance" "$road_condition" "$load_weight" "$status" >> "$HEALTH_REPORT_FILE"
}

check_battery_health() {
    local status
    # Base charge - distance factor - load factor
    battery_charge_val=$((90 - (trip_distance / 30) - (load_weight / 75)))
    if (( battery_charge_val < 0 )); then battery_charge_val=0; fi
    if (( battery_charge_val > 100 )); then battery_charge_val=100; fi

    if [ "$battery_charge_val" -le 20 ]; then
        status="${RED}🔴 Low Charge – Needs immediate recharging!${NC}"
    elif [ "$battery_charge_val" -le 50 ]; then
        status="${YELLOW}🟡 Moderate Charge – Recharge recommended.${NC}"
    else
        status="${GREEN}🟢 Healthy Charge.${NC}"
    fi
    printf "⚡ Battery Charge: %s%% | Trip: %skm | Load: %skg | Status: %s\n" \
        "$battery_charge_val" "$trip_distance" "$load_weight" "$status" >> "$HEALTH_REPORT_FILE"
}

check_engine_performance() {
    local status_temp
    local status_overall
    # Simulate sensor readings
    engine_temp_val=$((70 + RANDOM % 35)) # Range 70-104
    local avg_rpm=$((1500 + RANDOM % 3000)) # Range 1500-4499
    local oil_viscosity
    oil_viscosity=$(echo "scale=2; 4.5 + ($RANDOM % 15)/10" | bc) # Range 4.5 - 5.9

    if [ "$engine_temp_val" -ge 100 ]; then
        status_temp="${RED}High Temperature${NC}"
        status_overall="${RED}🔴 High Temperature – Consider inspection!${NC}"
    elif [ "$engine_temp_val" -ge 95 ]; then
        status_temp="${YELLOW}Elevated Temperature${NC}"
        status_overall="${YELLOW}🟡 Temp Elevated – Monitor closely.${NC}"
    else
        status_temp="${GREEN}Normal${NC}"
        status_overall="${GREEN}🟢 Normal Engine Parameters.${NC}"
    fi
    printf "🔥 Engine: Temp %s°C (%s) | Avg RPM: %s | Oil Visc: %s | Status: %s\n" \
        "$engine_temp_val" "$status_temp" "$avg_rpm" "$oil_viscosity" "$status_overall" >> "$HEALTH_REPORT_FILE"
}

check_suspension_wear() {
    local status
    # Base wear + distance factor + road factor
    suspension_wear_val=$((25 + (trip_distance / 20) + wear_modifier + (load_weight / 150)))
    if (( suspension_wear_val < 0 )); then suspension_wear_val=0; fi
    if (( suspension_wear_val > 100 )); then suspension_wear_val=100; fi


    if [ "$suspension_wear_val" -ge 70 ]; then
        status="${RED}🔴 Critical – Suspension tuning required!${NC}"
    elif [ "$suspension_wear_val" -ge 45 ]; then
        status="${YELLOW}🟡 Moderate wear – Inspect soon.${NC}"
    else
        status="${GREEN}🟢 Suspension in good condition.${NC}"
    fi
    printf "🔧 Suspension Wear: %s%% | Trip: %skm | Road: %s | Status: %s\n" \
        "$suspension_wear_val" "$trip_distance" "$road_condition" "$status" >> "$HEALTH_REPORT_FILE"
}

suggest_brake_maintenance() {
    local brake_status
    # Base wear + distance factor + road factor (brakes affected more by harsh conditions)
    brake_wear_val=$((15 + (trip_distance / 30) + (wear_modifier * 3 / 4) + (load_weight / 120)))
    if (( brake_wear_val < 0 )); then brake_wear_val=0; fi
    if (( brake_wear_val > 100 )); then brake_wear_val=100; fi

    local alignment_need=$((wear_modifier / 2)) # Simple alignment suggestion

    if [ "$brake_wear_val" -ge 70 ]; then
        brake_status="${RED}🔴 Urgent – Replace brakes!${NC}"
    elif [ "$brake_wear_val" -ge 45 ]; then
        brake_status="${YELLOW}🟡 Caution – Inspect brakes.${NC}"
    else
        brake_status="${GREEN}🟢 Brakes are fine.${NC}"
    fi
    printf "🛑 Brake Wear: %s%% | Status: %s\n" "$brake_wear_val" "$brake_status" >> "$HEALTH_REPORT_FILE"
    printf "🔄 Recommended Wheel Alignment Check: %s (based on road harshness)\n" "$alignment_need" >> "$HEALTH_REPORT_FILE"
}

generate_health_report() {
    get_trip_details

    printf "${MAGENTA}Generating Vehicle Health Report...${NC}\n"
    # Overwrite/create the log file for the new report
    {
        printf "${BLUE}⚠️ Reminder: Please manually inspect key components before operating the vehicle!${NC}\n"
        printf "${BLUE}🔹 Vehicle Health Analysis | $(date)${NC}\n"
        printf "------------------------------------------------------\n"
        printf "Trip Details: Distance: %skm, Load: %skg, Road: %s (Modifier: %s)\n" \
            "$trip_distance" "$load_weight" "$road_condition" "$wear_modifier"
        printf "------------------------------------------------------\n"
    } > "$HEALTH_REPORT_FILE" # Note: > overwrites the file

    check_tire_wear
    check_battery_health
    check_engine_performance
    check_suspension_wear
    suggest_brake_maintenance

    printf "------------------------------------------------------\n" >> "$HEALTH_REPORT_FILE"
    if [ "$tire_wear_val" -lt 50 ] && \
       [ "$battery_charge_val" -gt 50 ] && \
       [ "$engine_temp_val" -lt 95 ] && \
       [ "$suspension_wear_val" -lt 50 ] && \
       [ "$brake_wear_val" -lt 45 ]; then
        printf "${GREEN}✅ Overall Status: Vehicle appears in good condition for the entered trip details!${NC}\n" >> "$HEALTH_REPORT_FILE"
    else
        printf "${RED}⚠️ Overall Status: Some components require attention. Review details above.${NC}\n" >> "$HEALTH_REPORT_FILE"
    fi
    printf "------------------------------------------------------\n" >> "$HEALTH_REPORT_FILE"

    printf "${GREEN}✅ Report Generated: %s${NC}\n" "$HEALTH_REPORT_FILE"
    cat "$HEALTH_REPORT_FILE"
}

# --- Service Log Functions ---

log_service_entry() {
    local service_description
    printf "${CYAN}--- Log New Service Entry ---${NC}\n"
    printf "${BLUE}Enter service description (e.g., Oil change, Tire rotation): ${NC}"
    read service_description
    if [ -n "$service_description" ]; then
        printf "[$(date)] Service Performed: %s\n" "$service_description" >> "$SERVICE_LOG_FILE"
        printf "${GREEN}✅ Service entry logged to %s${NC}\n" "$SERVICE_LOG_FILE"
    else
        printf "${YELLOW}⚠️ No description entered. Service entry not logged.${NC}\n"
    fi
}

view_service_log() {
    printf "${CYAN}--- Vehicle Service History ---${NC}\n"
    if [ -s "$SERVICE_LOG_FILE" ]; then # Check if file exists and is not empty
        cat "$SERVICE_LOG_FILE"
    else
        printf "${YELLOW}No service history found or file is empty.${NC}\n"
    fi
    printf "------------------------------------------------------\n"
}

view_last_health_report() {
    printf "${CYAN}--- Last Vehicle Health Report ---${NC}\n"
    if [ -s "$HEALTH_REPORT_FILE" ]; then
        cat "$HEALTH_REPORT_FILE"
    else
        printf "${YELLOW}No health report found or file is empty.${NC}\n"
        printf "${YELLOW}Generate a new report first.${NC}\n"
    fi
    printf "------------------------------------------------------\n"
}


# --- Main Menu ---
main_menu() {
    while true; do
        printf "\n${MAGENTA}--- 🚗 Vehicle Health & Service Tracker ---${NC}\n"
        printf "${CYAN}1.${NC} Analyze Trip & Generate Health Report\n"
        printf "${CYAN}2.${NC} Log New Service Entry\n"
        printf "${CYAN}3.${NC} View Service History\n"
        printf "${CYAN}4.${NC} View Last Health Report\n"
        printf "${CYAN}5.${NC} Exit\n"
        printf "${BLUE}Please enter your choice: ${NC}"
        read choice

        case $choice in
            1)
                generate_health_report
                ;;
            2)
                log_service_entry
                ;;
            3)
                view_service_log
                ;;
            4)
                view_last_health_report
                ;;
            5)
                printf "${GREEN}Exiting Vehicle Health & Service Tracker. Safe travels!${NC}\n"
                exit 0
                ;;
            *)
                printf "${RED}Invalid option. Please try again.${NC}\n"
                ;;
        esac
        printf "${BLUE}Press Enter to continue...${NC}"
        read -r
        clear # Clears the screen for the next menu display - optional
    done
}

# --- Script Execution ---
clear
check_dependencies
initialize_logs
main_menu