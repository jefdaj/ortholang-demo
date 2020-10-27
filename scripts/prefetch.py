#!/usr/bin/env python

# This is ugly but generates a decent "prefetch everything" ortholang script.
# Afterwards, comment out any variables you don't want to fetch.
# The final script should go in the examples dir, then call demo.py --prefetch to actually prefetch everything.

import json

def print_varnames(varname, varnames):
  print varname + ' =\n [ ' + '\n , '.join(varnames) + '\n ]'

if __name__ == '__main__':
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
  print_varnames('pdbs', varnames)
  
  print
  print '# NCBI BLAST nucleotide databases'
  print
  varnames = []
  for db in dbs:
      if db['type'] == 'ndb':
        print '%s = %s' % (db['basename'], db['loadfn'])
        varnames.append(db['basename'])
  print
  print_varnames('ndbs', varnames)
  
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
  print_varnames('fnas', varnames)
  
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
  print_varnames('faas', varnames)
  print
  print '# force evaluation of all the lists'
  print_varnames('result', ['length pdbs', 'length ndbs', 'length fnas', 'length faas'])
