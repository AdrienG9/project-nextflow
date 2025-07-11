#!/bin/bash -ue
echo "=== EXTRACTION VERIFICATION REPORT ===" > extraction_report.txt
echo "Extraction completed at: $(date)" >> extraction_report.txt
echo "" >> extraction_report.txt

echo "Files extracted:" >> extraction_report.txt
cat file_list.txt >> extraction_report.txt
echo "" >> extraction_report.txt

echo "Total number of files: $(cat file_list.txt | wc -l)" >> extraction_report.txt
echo "Total size of extracted files: $(du -sh extracted 2>/dev/null | cut -f1 || echo 'N/A')" >> extraction_report.txt

echo "" >> extraction_report.txt
echo "File types found:" >> extraction_report.txt
find extracted -type f -name "*.*" | sed 's/.*\.//' | sort | uniq -c | sort -nr >> extraction_report.txt
