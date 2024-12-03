import csv
import sys
import pandas as pd


unique_rows = set()
duplicate_rows = []
reader = csv.reader(sys.stdin)
header = next(reader)
for row in reader:
    row_tuple = tuple(row)
    if row_tuple in unique_rows:
        duplicate_rows += row,
    else:
        unique_rows.add(row_tuple)


df = pd.DataFrame(unique_rows, columns=header)
df.to_csv(sys.stdout, index=False)
