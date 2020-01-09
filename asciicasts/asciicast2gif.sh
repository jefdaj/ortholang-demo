#!/usr/bin/env bash

# This works, but is rediculously slow. Try leaving it overnight.
# TODO fiddle with the limits to speed it up?

docker pull asciinema/asciicast2gif

for cast in *.cast; do
  gif="${cast/.cast/.gif}"
  [[ -a $gif ]] && continue
  docker run \
	  --rm \
	  -e "GIFSICLE_OPTS=--lossy=80" \
	  -e "NODE_OPTS=--max-old-space-size=12288" \
	  -e "MAGICK_MEMORY_LIMIT=6gb" \
	  -e "MAGICK_MAP_LIMIT=12gb" \
	  -v $PWD:/data \
		asciinema/asciicast2gif \
	  -s 2 \
	  $cast $gif
done
