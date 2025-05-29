# ✅ Generate Final Vehicle Health Report (Table Format)
echo -e "\n${BLUE}📊 Vehicle Health Summary Report${NC}" >> "$LOG_FILE"
echo -e "------------------------------------------------------" >> "$LOG_FILE"
echo -e "| Component          | Wear %    | Status                             | Recommendation                   |" >> "$LOG_FILE"
echo -e "----------------------------------------------------------------------------------------------" >> "$LOG_FILE"
echo -e "| Tires             | $tire_wear%   | $status    | Inspect before long trips       |" >> "$LOG_FILE"
echo -e "| Battery           | $charge_status%   | $status    | Recharge if below 50%          |" >> "$LOG_FILE"
echo -e "| Engine Temp       | $engine_temp°C   | $status    | Check cooling if over 100°C    |" >> "$LOG_FILE"
echo -e "| Suspension        | $suspension_wear%   | $status    | Tune if wear exceeds 50%       |" >> "$LOG_FILE"
echo -e "| Brakes           | $brake_wear%   | $brake_status    | Replace if over 75% wear       |" >> "$LOG_FILE"
echo -e "| Wheel Alignment  | ${alignment_need}°   | $status    | Adjust if misaligned         |" >> "$LOG_FILE"
echo -e "----------------------------------------------------------------------------------------------" >> "$LOG_FILE"

# 🚦 Final Summary – Is the vehicle good to go?
if [[ "$tire_wear" -lt 50 && "$charge_status" -gt 50 && "$engine_temp" -lt 100 && "$suspension_wear" -lt 50 && "$brake_wear" -lt 50 ]]; then
    echo -e "${GREEN}✅ Your vehicle is in good condition for the entered distance. Drive Safe & Enjoy with Your Family!${NC}" >> "$LOG_FILE"
else
    echo -e "${RED}⚠️ Some components need attention before your trip! Please check manually.${NC}" >> "$LOG_FILE"
fi
