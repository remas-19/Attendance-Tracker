#!/bin/bash

# Main interface to  attendance system
 
# the menu

while true; do
    echo ""
    echo "===== Attendance Tracker Menu ====="
    echo "1) Generate Attendance Report"
    echo "2) Search for a Student and Generate Alerts"
    echo "3) Exit"
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1)
            # Run the script that generates attendance report.
            bash Remas.sh
            ;;
        2)
            # Run the script that searches for a student and creates alerts
            bash mrmrnew.sh
            ;;
        3)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, or 3."
            ;;
    esac
done
