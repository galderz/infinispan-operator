#!/usr/bin/python3

import yaml
import sys


def main():
    yaml_file = sys.argv[1]
    format_yaml(yaml_file)


def format_yaml(yaml_file):
    with open(yaml_file, 'r') as f:
        doc = yaml.safe_load(f)

    with open(yaml_file, 'w') as f:
        yaml.dump(doc, f)


if __name__ == '__main__':
    main()
