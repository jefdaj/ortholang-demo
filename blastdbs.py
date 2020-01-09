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
	db_dir = '/mnt/data/shortcut-shared/cache/blastdbget'
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
			pass
		js.append(j)
	return js

if __name__ == '__main__':
	js = []
	descs = read_descs()
	# print descs

	js += read_dbs('n', descs)
	js += read_dbs('p', descs)
	# print js

	with open('templates/blastdbs.json', 'w') as f:
		f.write(json.dumps(js, indent=2))

		# write load-blastdbs.ol (for prefetching)
		with open('ortholang/examples/scripts/load-blastdbs.ol', 'w') as f:
			for j in js:
				cmd = 'ncbi_%s = %s ' % (j['basename'], j['loadfn'])
				f.write(cmd + '\n')
			resline = 'result = "nothing so far"'
			f.write(resline)
