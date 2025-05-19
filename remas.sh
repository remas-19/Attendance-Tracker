#!/bin/bash 

# Ask the user to enter the name of the CSV file
read -p "Enter CSV file name: " file

# Check if the file exists
if [[ ! -f "$file" ]]; then
  echo "Error: File '$file' not found."  # Show error if file doesn't exist
  exit 1  # Exit the script with error
fi

# Create a folder called "Reports" if it doesn't already exist
mkdir -p Reports

# Create a report filename with today's date
report="Reports/report_$(date +%F).txt"

# Use awk to read the CSV file and calculate attendance percentage
awk -F',' 'NR>1 {
  name = $1          # Column 1: student name
  p = $2 + 0          # Column 2: present days
  a = $3 + 0          # Column 3: absent days
  t = p + a           # Total sessions

  if (t > 0) {
    percent = (p / t) * 100                    # Calculate attendance %
    status = (percent >= 75) ? "✅" : "❌"     # Mark ✅ if >=75%, else ❌
    printf "%s | %.1f%% | %s\n", name, percent, status  # Print line
  } else {
    printf "%s | --- | No Data\n", name       # Handle if total is 0
  }
}' "$file" > "$report"  # Write output to report file

# Print a message and show the report content
echo "✅ Report generated and saved in: $report"
echo "📅 Date: $(date +%F)"
echo "────────────────────────────"
cat "$report"             # Display the report
