import argparse
import json
from fixPactContract import fix_pact_contract


parser = argparse.ArgumentParser(description='Fixes PACT contract file.')
parser.add_argument('filein', metavar='FILEIN', type=str, help='PACT contract file to fix')
parser.add_argument('fileout', metavar='FILEOUT', type=str, help='Filename where the updated PACT will be written to')

args = parser.parse_args()

with open(args.filein, 'r') as file_input:
    json_input = json.load(file_input)
    json_output = fix_pact_contract(json_input)

    with open(args.fileout, 'w') as file_output:
        json.dump(json_output, file_output, indent=4)
