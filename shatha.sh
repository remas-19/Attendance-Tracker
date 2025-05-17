#!/bin/bash

DATA_DIR="data"
THRESHOLD_ABSENCE=3

read_attendance_data() {
    local file="$1"
    [[ -f "$file" ]] || {
        whiptail --msgbox "Error: The file '$file' does not exist." 10 50
        return 1
    }

    declare -A attendance student_names
    while IFS=',' read -r student_id student_name date status; do
        attendance["$student_id"]+="$date:$status "
        student_names["$student_id"]="$student_name"
    done < "$file"
}

main_menu() {
    while true; do
        choice=$(whiptail --menu "Attendance Management" 20 60 5 \
            "1" "Analyze Attendance" \
            "2" "Search Student" \
            "3" "Alert Low Attendance" \
            "4" "Exit" \
            --ok-button "Ok" --cancel-button "Cancel" 3>&1 1>&2 2>&3)

        msg=""
        case "$choice" in
            1) msg="Analyzing attendance..." ;;
            2) msg="Searching student..." ;;
            3) msg="Checking for low attendance..." ;;
            4) msg="Exiting the application..."; break ;;
            "") break ;;
            *) msg="Invalid option." ;;
        esac

        [[ -n "$msg" ]] && whiptail --msgbox "$msg" 10 50
    done
}

main_menu
