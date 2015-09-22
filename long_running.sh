#!/bin/bash

[[ $# -ne 2 ]] && exit 1
TRAVIS_BUILD_DIR="$1"
Gen="$2"

./gen.escript $TRAVIS_BUILD_DIR $TRAVIS_BUILD_DIR/other $TRAVIS_BUILD_DIR/$Gen &
pid=$!
while kill -0 $pid; do echo -n .; sleep 0.5; done
