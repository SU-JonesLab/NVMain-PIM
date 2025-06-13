#!/usr/bin/python
from optparse import OptionParser
from random import random

# Define PIM Operations
PIM_OPS = [ "T" ]

# Parse CLA
parser = OptionParser()
parser.add_option("-i","--input_file", help="Input (clean) trace file to read", action="store", type="string", dest="input_file")
parser.add_option("-o","--output_file", help="Output (faulty) trace file to write", action="store", type="string", dest="output_file")
parser.add_option("-f","--fault_rate", help="Bitwise fault rate for PIM operations", action="store", type="int", default=1e-6, dest="fault_rate")

(options, args) = parser.parse_args()
input_file = options.input_file
fault_rate = options.fault_rate
output_file = options.output_file
if output_file == None:
    # Remove extension
    output_file = input_file.split('.')
    # Add _faulty to the end then add the extension back
    output_file = output_file[0] + '_faulty.' + input_file.split('.')[-1]

output = []
# Check if input file exists
try:
    with open(input_file, 'r') as f:
        lines = f.readlines()
        
        if lines[0][0] == '>': # Header line
            if lines[0].contains('Faulty'):
                print(f"Input file {input_file} is already faulty")
                exit(1)
            else:
                output.append(lines[0].strip() + ' Faulty')
        else:
            print("Input file does not have a header line, exiting")
            exit(1)
    
    # Loop through each trace line in the input file
    for line in lines[1:]:
        output.append(line.strip())
        # Check if the line is a PIM operation
        if line[0] in PIM_OPS:
            # Randomly decide whether to inject a fault
            while random() < fault_rate: # while loop bc injected recomputation may also fail
                # Inject lower-bound on recomputation
                output.append(line.strip())    
except:
    print(f"Input file {input_file} does not exist")
    exit(1)

# Write the output to the output file
with open(output_file, 'w') as f:
    for line in output:
        f.write(line + '\n')
print(f"Output file {output_file} written successfully")