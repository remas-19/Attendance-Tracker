#!/bin/bash

#Ask the user to enter a student name to search
read -p "Enter student name to search: " query

#Search for the student in the CSV file (case-insensitive)
echo "Search Results:"
grep -i "$query" students.csv > /dev/null 2>&1

if [ $? -ne 0 ]; then
    #If no matching student found, show message
    echo "No matching student found."
else
    #If found, print details and check absence ratio
    grep -i "$query" students.csv | while IFS=',' read -r name present absent hours
    do
        #Calculate total attendance days
        total=$((present + absent))
        if [ $total -gt 0 ]; then
            # Calculate absence ratio as percentage
            absence_ratio=$(echo "scale=2; $absent*100/$total" | bc)
            # Print student details and absence ratio
            echo "Student: $name, Present Days: $present, Absent Days: $absent, Hours: $hours"
            echo "Absence ratio: $absence_ratio%"
            # Check if absence ratio exceeds 25%
            absence_check=$(echo "$absence_ratio > 25" | bc)
            if [ "$absence_check" -eq 1 ]; then
                # Print alert message if absence is high
                echo "ALERT: You have exceeded 25% absence."
            fi
        else
            # If total days is zero or invalid data
            echo "Data insufficient for $name"
        fi
    done
fi

# Generate alert file for all students with absence ratio > 25%
echo "Generating absence alerts..."
awk -F',' 'NR>1 {
    total = $2 + $3
    if (total > 0) {
        ratio = $3 / total
        if (ratio > 0.25) {
            printf("%s has high absence rate (%.2f%%) - You have exceeded 25%% absence.\n", $1, ratio*100)
        }
    }
}' students.csv > alerts.txt

# Create Alerts directory if not exist
mkdir -p Alerts

# Rename alert file with today's date (format: YYYY-MM-DD)
today=$(date +%F)
mv alerts.txt Alerts/alerts_$today.txt

# Create Reports directory if not exist and copy alert file there as backup
mkdir -p Reports
cp Alerts/alerts_$today.txt Reports/

# Final confirmation message
echo " Alerts generated and saved in Alerts/ and Reports/"
