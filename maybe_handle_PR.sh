#!/bin/bash -x

# $0  $TRAVIS_PULL_REQUEST $TRAVIS_BUILD_DIR

[[ $# -ne 2 ]] && exit 1
TRAVIS_PULL_REQUEST="$1"
TRAVIS_BUILD_DIR="$2"
[[ $TRAVIS_PULL_REQUEST == false ]] && exit 0

cd $TRAVIS_BUILD_DIR
[[ ! -f gen ]] && exit 3
mkdir other \
    && git clone https://github.com/erldocs/erldocs_other.git erldocs_other.git \
    && cd erldocs_other.git \
    && make -j app \
    && ./gen.escript $TRAVIS_BUILD_DIR $TRAVIS_BUILD_DIR/other $TRAVIS_BUILD_DIR/gen \
    && cd $TRAVIS_BUILD_DIR \
    && rm -rf other/* erldocs_other.git/* gen \
    && echo 'apps = [' >apps.js \
    && find . -name meta.txt | cut -c3- | sed 's/.........$/",/' | sed 's/^/"/' | tr -d '\n' >>apps.js \
    && echo '];' >>apps.js \
    && git add -A . \
    && git commit -m "Close PR #$TRAVIS_PULL_REQUEST: successfully applied" \
    && git push origin gh-pages
