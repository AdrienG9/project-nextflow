#!/bin/bash -ue
# Create extraction directory
mkdir -p extracted

# Extract the archive
tar -xzf results.tar.gz -C extracted

# Create a list of extracted files
find extracted -type f > file_list.txt

echo "Extraction completed. Files extracted to: extracted/"
echo "Number of files extracted: $(find extracted -type f | wc -l)"
