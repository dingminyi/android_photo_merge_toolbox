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

# Specify the directory where your files are located
directory="/path/to/files"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory not found: $directory"
    exit 1
fi

# Iterate through files in the directory
for file in "$directory"/*; do
    if [ -f "$file" ]; then
        # Get the modification time of the file (cross-platform)
        if [ "$(uname)" == "Darwin" ]; then
            mtime=$(stat -f "%m" "$file")
        else
            mtime=$(stat -c "%Y" "$file")
        fi

        # Format the modification time as "YYYYMMDD_HHMMSS"
        newname=$(date -r "$mtime" "+%Y%m%d_%H%M%S")
        
        # Preserve the file extension
        extension="${file##*.}"

        # Preserve the original file name (without extension) 
        filename_without_extension=$(basename "${file%.*}")

        new_filename="${newname}_${filename_without_extension}.${extension}"
        
        # Rename the file with the new name and the preserved extension
        mv "$file" "${directory}/${new_filename}"
        
        echo "Renamed: $file -> ${directory}/${new_filename}"
    fi
done
