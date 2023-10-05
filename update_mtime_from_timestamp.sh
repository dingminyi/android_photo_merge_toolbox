#!/bin/bash

# Copyright 2023 Minyi Ding
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# traverse file
input_file="/sdcard/path/to/filelist.txt"

# Define the time pattern regex
time_pattern="20[0-9]{6}_[0-9]{6}"

line_number=1

# Traverse files in the specified folder
while read -r file; do
  # Extract the file name without the path
  file_name=$(basename "$file")

  # Check if the file name contains the time pattern
  if echo "$file_name" | grep -qE "$time_pattern"; then
    # Extract the matched time pattern
    time_string=$(echo "$file_name" | grep -oE "$time_pattern")
    
    # Convert the time pattern to a usable timestamp
    timestamp=$(date -d "${time_string:0:4}-${time_string:4:2}-${time_string:6:2} ${time_string:9:2}:${time_string:11:2}:${time_string:13:2}" +"%Y%m%d%H%M.%S")

    # Update the file's modification time
    touch -t "$timestamp" "$file"
    
    # Print a message indicating the change
    echo "Line $line_number: Changed modification time of '$file' to '$timestamp'"
  fi
  ((line_number++))
done < "$input_file"

echo "Modification times updated for files with the specified time pattern."
