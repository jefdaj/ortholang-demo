#!/usr/bin/env python

# This is ugly but generates a decent "prefetch everything" ortholang script.
# Afterwards, comment out any variables you don't want to fetch.
# The final script should go in the examples dir, then call demo.py --prefetch to actually prefetch everything.

import json

def print_list(varname, elems):
  print varname + ' =\n [ ' + '\n , '.join(elems) + '\n ]'

if __name__ == '__main__':

  print '# This is a special script included in the examples to force caching'
  print '# all the example data on the server. It will take a while to run and'
  print '# cache a large amount of data (several hundred GB)'
  print

  lists = []

  with open('data/blastdbs.json', 'r') as f:
    dbs = json.load(f)
  
  dbs = sorted(dbs, key=lambda db: db['type'] + db['basename'])
  
  print '# NCBI BLAST protein databases'
  print
  varnames = []
  for db in dbs:
      if db['type'] == 'pdb':
        print '%s = %s' % (db['basename'], db['loadfn'])
        varnames.append(db['basename'])
  print
  print_list('pdbs', varnames)
  lists.append('length pdbs')
  
  print
  print '# NCBI BLAST nucleotide databases'
  print
  varnames = []
  for db in dbs:
      if db['type'] == 'ndb':
        print '%s = %s' % (db['basename'], db['loadfn'])
        varnames.append(db['basename'])
  print
  print_list('ndbs', varnames)
  lists.append('length ndbs')
  
  with open('data/fastas.json', 'r') as f:
    fas = json.load(f)
  
  fas = sorted(fas, key=lambda fa: fa['type'] + fa['basename'])
  
  print
  print '# Phytozome V12 fasta nucleic acid files'
  print
  varnames = []
  for fa in fas:
      if fa['type'] != 'fna':
          continue
      varname = fa['basename'].replace('.fa', '').replace('.', '_').replace('-', '_')
      varnames.append(varname)
      print '%s = %s' % (varname, fa['loadfn'])
  print
  print_list('fnas', varnames)
  lists.append('length fnas')
  
  print
  print '# Phytozome V12 fasta amino acid files'
  print
  varnames = []
  for fa in fas:
      if fa['type'] != 'faa':
          continue
      varname = fa['basename'].replace('.fa', '').replace('.', '_').replace('-', '_')
      varnames.append(varname)
      print '%s = %s' % (varname, fa['loadfn'])
  print
  print_list('faas', varnames)
  lists.append('length faas')

  print
  print '# force evaluation of all the lists'
  print_list('result', lists)
