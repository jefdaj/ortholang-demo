#!/usr/bin/env python

import json
import re
from glob import glob
from os.path import basename, splitext, join

def read_descs():
	with open('templates/blastdb-descriptions.txt', 'r') as f:
		lines = [l + ' ' for l in f.read().split('\n')]
	descs = {}
	for line in lines:
		if len(line) == 0:
			continue
		# print 'line: "%s"' % line
		vs = [v.strip() + ' ' for v in line.split('|', 2)]
		k = vs[0].strip()
		v = ''.join(vs[1:]).strip()
		if len(k) == 0 or len(v) == 0:
			continue
		descs[k] = v
	return descs

def read_dbs(n_or_p, descs):
	js = []
	db_dir = '/mnt/data/ortholang-shared/cache/blastdbget'
	dbs = glob(join(db_dir, '*.' + n_or_p + '*'))
	dbs = set(d.split('.')[0] for d in dbs)
	# print dbs
	if n_or_p == 'n':
		nucl_or_prot = 'nucl'
	else:
		nucl_or_prot = 'prot'
	for d in dbs:
		j = {
			'type': n_or_p + 'db',
			'basename': basename(d),
			'loadfn': 'blastdbget_' + nucl_or_prot + ' "%s"' % basename(d)
		}
		try:
			j['description'] = descs[basename(d)]
		except:
			j['description'] = "NCBI " + basename(d) + " BLAST database"
		js.append(j)
	js.sort(key=lambda j: j['basename'])
	return js

def varname(db_json):
	# prevent invalid varnames
	dbname = db_json['basename']
	if dbname == '16SMicrobial':
		return 'microbial16s'
	return dbname

if __name__ == '__main__':
	# js = []
	descs = read_descs()
	# print descs

	ns = read_dbs('n', descs)
	ps = read_dbs('p', descs)
	js = ns + ps
	# print js

	with open('templates/blastdbs.json', 'w') as f:
		f.write(json.dumps(js, indent=2))

		# write load-blastdbs.ol (for prefetching)
		with open('ortholang/examples/scripts/load-blastdbs.ol', 'w') as f:
			for j in js:
				cmd = '%s = %s ' % (varname(j), j['loadfn'])
				f.write(cmd + '\n')
			ns_str = 'ndbs = [' + ', '.join(varname(n) for n in ns) + ']'
			ps_str = 'pdbs = [' + ', '.join(varname(p) for p in ps) + ']'
			res_str = 'result = length_each [ndbs, pdbs]'
			for s in [ns_str, ps_str, res_str]:
				f.write(s + '\n')
