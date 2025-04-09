#!/usr/bin/env python3
import sys
import csv

def build_tilemap(csv_path):
    with open(csv_path, newline='') as csvfile:
        reader = list(csv.reader(csvfile))
        height = len(reader)
        width = len(reader[0]) if height > 0 else 0

        # Output width and height as one byte each
        sys.stdout.buffer.write(bytes([width, height]))

        for row in reader:
            row_bytes = [int(cell.strip()) for cell in row]
            sys.stdout.buffer.write(bytes(row_bytes))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 build_tilemap.py <csv_tilemap>", file=sys.stderr)
        sys.exit(1)

    csv_file = sys.argv[1]
    build_tilemap(csv_file)
