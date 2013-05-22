#!/bin/bash
# instantiate template
# usage: ./instantiate.sh prefix style
# e.g. ./instantiate.sh aio1 allinone
set -o nounset
set -e
PREFIX=$1
STYLE=$2
sed s/\$\{PREFIX\}/${PREFIX}/ $STYLE.json.template > ${PREFIX}.json

