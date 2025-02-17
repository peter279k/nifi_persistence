import csv
import sys
import datetime
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


metadata_json = {
    'user': 'peter',
    'file_name': __file__,
    'version': '1.0',
    'processed_date': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
}
print(metadata_json)

df = pd.DataFrame(unique_rows, columns=header)
df.to_csv('/tmp/train.csv', index=False)
