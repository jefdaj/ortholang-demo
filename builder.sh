#!/usr/bin/env bash

source ${stdenv}/setup

# copy files
mkdir -p $out/src
cp -R ${src}/templates ${src}/static ${src}/data $out/src
chmod +w $out/src/data $out/src/templates

# install the ortholang-demo binary
mkdir -p $out/bin
dest="$out/bin/ortholang-demo"
install -m755 ${src}/demo.py $dest
wrapProgram $dest --prefix PATH : "${binPath}"

# generate prefetch script
cd $src
python ${src}/scripts/prefetch.py > $out/src/data/prefetch.ol

# generate functions reference tab
${demoDocs}/bin/docs $out/src
