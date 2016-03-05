#!/usr/bin/python

import argparse

import sys
import getopt
import os


parser = argparse.ArgumentParser(description='Create a foo.txt inside the given folder.')

parser.add_argument('-d', '--directory', help='Directory where to put the foo.txt')

args = parser.parse_args()

fooFilePath = os.path.join(args.directory, 'foo.txt')
print args.directory
print fooFilePath
if os.path.isdir(args.directory):
    print 'yes'
else:
    print 'no!'
    os.mkdir(args.directory)

with open(fooFilePath, 'w') as foo:
        foo.write('Hello world!')

