#!/usr/bin/env bash

# set -e

guess_url() { echo "https://phytozome.jgi.doe.gov/pz/portal.html#!info?alias=Org_${1}"; }
grep_alias() { egrep -o '\?alias=.*' "$1"  | cut -d'=' -f2 | cut -d'_' -f2- | cut -d'"' -f1 | cut -d' ' -f1 | cut -d$'\n' -f1 | sed 's/_er//g'; }
grep_org() { egrep -o '<span>\(.*\)</span>' "$1" | cut -d'(' -f2 | cut -d')' -f1; }

cd /mnt/data/PhytozomeV12

# i downloaded the portal pages with a firefox plugin since they require javascript
# this moves them to their proper organism folders
for f in /home/jefdaj/ortholang-demo/portals/*.html; do
  a=$(grep_alias "$f")
  # cp "$f" "${a}/portal.html" || echo "no dir: $a"
  d=early_release/$(ls early_release | grep $a)
  [[ "$d" == early_release/ ]] && continue
  # echo "dir: $d"
  cp "$f" ${d}/portal.html || echo "no dir: $a"
done
# find -name portal.html | wc -l

# next, we make a simpler table of alias, common name to load in genomes.py
find -name portal.html | while read f; do
  a=$(grep_alias "$f")
  o=$(grep_org "$f")
  echo -e "${a}\t${o}"
done > common-names.tsv
