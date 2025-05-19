#!/bin/bash 

mkdir -p Reports  # Create "Reports" folder if not exist

while true; do  # Start main menu loop

  echo ""
  echo "Attendance Tracker"
  echo "1) Analyze Attendance File"
  echo "2) View Last Report"
  echo "3) Show Students with < 50% Attendance"
  echo "4) Exit"
  echo -n "Enter your choice: "
  read choice  # Get user input

  case $choice in

    1)  # Analyze attendance file
      echo -n "Enter CSV file name: "
      read file  # Read file name

      if [[ ! -f "$file" ]]; then
        echo "File not found!"
        continue
      fi

      report="Reports/report_$(date +%Y-%m-%d).txt"  # Output file with date

      awk -F',' 'NR>1 {
        name = $1
        p = $2 + 0
        a = $3 + 0
        t = p + a

        if (t > 0) {
          percent = (p / t) * 100
          status = (percent >= 75) ? "✅" : "❌"
          printf "%s | %.1f%% | %s\n", name, percent, status
        } else {
          printf "%s | --- | No Data\n", name
        }
      }' "$file" | tee "$report"  # Save and display output

      echo "Report saved to: $report"
      ;;

    2)  # Show last saved report
      last=$(ls -t Reports/report_*.txt 2>/dev/null | head -n 1)

      if [[ -f "$last" ]]; then
        echo ""
        echo "Last Report:"
        cat "$last"
      else
        echo "No reports found."
      fi
      ;;

    3)  # Show students with attendance < 50%
      last=$(ls -t Reports/report_*.txt 2>/dev/null | head -n 1)

      if [[ ! -f "$last" ]]; then
        echo "No reports found to filter."
        continue
      fi

      echo ""
      echo "Students with < 50% Attendance:"

      grep "❌" "$last" | awk -F'|' '{
        gsub(/%/, "", $2)
        if ($2 + 0 < 50) print
      }' | sed 's/|/│/g'

      echo ""
      ;;

    4)  # Exit
      echo "Thank you for using Attendance Tracker!"
      exit
      ;;

    *)  # Invalid input
      echo "Invalid choice."
      ;;
  esac
done
