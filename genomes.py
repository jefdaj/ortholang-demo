#!/usr/bin/env python

import json
from glob import glob
from os.path import basename

def list_dirs():
    dirs = glob('/mnt/data/PhytozomeV12/*') + glob('/mnt/data/PhytozomeV12/early_release/*')
    # print dirs
    return dirs

def find_readme(d):
    try:
        return glob(d + '/*readme*')[0]
    except IndexError:
        return None

def find_organism(d):
    r = find_readme(d)
    if r is None:
        return None
    with open(r, 'r') as f:
        for l in f.readlines():
            if l.startswith('Organism'):
                o = ' '.join(l.split(' ')[2:])[:-1]
                return o
    return '???'

def find_protein(d):
    try:
        return glob(d + '/annotation/*protein*.fa')[0]
    except IndexError:
        return '???'

def guess_url(d):
    n = '_'.join(basename(d).split('_')[:1])
    if 'early_release' in d:
        n += '_er'
    return 'https://phytozome.jgi.doe.gov/pz/portal.html#!info?alias=Org_%s' % n

def common_names():
    names = {}
    with open('common-names.tsv', 'r') as f:
        for l in f.readlines():
            k, v = l.split('\t')
            v = v.strip()
            names[k] = v
    return names

def load_fn(path, ltype):
    return 'load_%s "%s"' % (ltype, path)

def guess_type(path):
    if 'protein' in path:
        return 'faa'
    if 'cds' in path or 'transcript' in path or 'pep' in path:
        return 'fna'
    raise Exception('What type? %s' % path)

if __name__ == '__main__':
    dirs = list_dirs()
    names = common_names()
    # for n in names:
    #     print n, names[n]
    js = []
    for d in dirs:
        fs = glob(d + '/annotation/*.fa')
        # print d
        # print fs
        # if '.' in d or 'global' in d or d == 'early':
        #     continue
        for f in fs:
            j = {'organism': find_organism(d), 'path': f, 'type': guess_type(f)}
            a = basename(d).split('_')[0]
            # print a
            try:
                j['commonname'] = names[a]
            except KeyError:
                j['commonname'] = ''
            if j['organism'] is None:
                continue
            j['source'] = 'PhytozomeV12'
            j['url'] = guess_url(d)
            j['pre-release'] = 'early_release' in j['path']
            j['relpath'] = '/'.join(j['path'].split('/')[3:])
            j['basename'] = basename(j['relpath'])
            j['loadfn'] = load_fn(j['relpath'], j['type'])
            # if 'Hannu' in d:
              # print j
            js.append(j)
    with open('/home/jefdaj/shortcut-demo/templates/genomes.json', 'w') as f:
        f.write(json.dumps(js, indent=2))
