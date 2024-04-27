#!/bin/bash
output=$(sensors | grep 'Core ' | awk '{print $3}')

tooltip=""
core_number=1
numeric_value=0

extract_numeric() {
    local string="$1"
    #local numeric_value=$(echo "$string" | grep -oE '[+-]?[0-9]+([.][0-9]+)?')

    local numeric_value=$(echo "$string" | grep -oE '[+-]?[0-9]+' | head -n 1)
    echo "$numeric_value"
}

while IFS= read -r line; do
    tooltip+="Core $core_number: $line\n"

    numeric_value=$((numeric_value + $(extract_numeric "$line")))
    ((core_number++))
done <<< "$output"

result=$((numeric_value/ (core_number -1)))
echo "{\"text\": \"$result\", \"tooltip\": \"$tooltip\", \"class\": \"temperature\"}"
