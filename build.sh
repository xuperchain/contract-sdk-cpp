#!/bin/bash
set -e 

cd `dirname $0`

# install docker in precondition
if ! command -v docker &>/dev/null; then
    echo "missing docker command, please install docker first."
    exit 1
fi

# check if xdev available
if ! command -v xdev &>/dev/null; then
    echo "missing xdev command, please install xdev first"
    exit 1
fi

# build examples
mkdir -p build
for elem in `ls example|grep -v data_auth|grep -v paillier|grep -v trustops|grep -v xrc01`; do
    cc=example/$elem

    # build single cc file
    if [[ -f $cc ]]; then
        out=build/$(basename $elem .cc).wasm
        echo "build $cc"
        xdev build -o $out $cc
    fi

    # build package
    if [[ -d $cc ]]; then
        echo "build $cc"
        bash -c "cd $cc && xdev build && mv -v $elem.wasm ../../build/"
    fi
    echo 
done

