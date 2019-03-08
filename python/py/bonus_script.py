import sys

file_with_keys = sys.argv[1]

keys = [tuple(line.rstrip('\n').split(',')) for line in open(file_with_keys,'r')]

for line in sys.stdin:
    *key, value = line.strip().split(',')

    if tuple(key) in keys:
        print(value)