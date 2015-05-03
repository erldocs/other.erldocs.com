#!/bin/bash -x

# $0  $TRAVIS_PULL_REQUEST $TRAVIS_BUILD_DIR $GHT

[[ $# -ne 3 ]] && exit 1
TRAVIS_PULL_REQUEST="$1"
TRAVIS_BUILD_DIR="$2"
GHT="$3"
[[ $TRAVIS_PULL_REQUEST == false ]] && exit 0

cd $TRAVIS_BUILD_DIR
[[ ! -f gen ]] && exit 3
mkdir other \
    && git clone https://github.com/erldocs/erldocs_other.git erldocs_other.git \
    && cd erldocs_other.git \
    && make -j app \
    && ./gen.escript $TRAVIS_BUILD_DIR $TRAVIS_BUILD_DIR/other $TRAVIS_BUILD_DIR/gen \
    && cd $TRAVIS_BUILD_DIR \
    && rm -rf other/ erldocs_other.git/ gen \
    && touch gen \
    && echo 'apps = [' >apps.js \
    && find . -name meta.txt | cut -c3- | sed 's/.........$/",/' | sed 's/^/"/' | tr -d '\n' >>apps.js \
    && echo '];' >>apps.js \
    && git remote set-url --push origin https://"$GHT"@github.com/erldocs/other.erldocs.com.git \
    && git config user.email travis@atdot.dot \
    && git config user.name 'Travis CI' \
    && git add -A . \
    && git commit -m "Close PR #$TRAVIS_PULL_REQUEST: successfully applied" \
    && git push origin gh-pages
