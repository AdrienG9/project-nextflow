#!/bin/bash -ue
# Extract header from the first file
head -n 1 $(ls exp_index_3.csv exp_index_2b.csv exp_index_1b.csv exp_index_2a.csv exp_index_1a.csv | head -n 1) > data.csv

# Append all rows, skipping headers
for f in exp_index_3.csv exp_index_2b.csv exp_index_1b.csv exp_index_2a.csv exp_index_1a.csv; do
  tail -n +2 "$f"
done | sort -t, -k1,1V -k2,2n >> data.csv
