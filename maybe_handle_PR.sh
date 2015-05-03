#!/bin/bash -x

# $0  $TRAVIS_PULL_REQUEST $TRAVIS_BUILD_DIR $GHT

[[ $TRAVIS_PULL_REQUEST == false ]] && exit 0

cd $TRAVIS_BUILD_DIR
[[ ! -f todo.txt ]] && exit 3
mkdir other \
    && cp todo.txt gen \
    && export PR_commit=$TRAVIS_COMMIT \
    && git checkout gh-pages \
    && git clone https://github.com/erldocs/erldocs_other.git erldocs_other.git \
    && cd erldocs_other.git \
    && make -j app \
    && ./gen.escript $TRAVIS_BUILD_DIR $TRAVIS_BUILD_DIR/other $TRAVIS_BUILD_DIR/gen \
    && cd $TRAVIS_BUILD_DIR \
    && rm -rf other/ erldocs_other.git/ todo.txt \
    && echo 'apps = [' >apps.js \
    && find . -name meta.txt | cut -c3- | sed 's/.........$/",/' | sed 's/^/"/' | tr -d '\n' >>apps.js \
    && echo '];' >>apps.js \
    && git remote set-url --push origin https://$GHT@github.com/erldocs/other.erldocs.com.git \
    && git config user.email travis@atdot.dot \
    && git config user.name 'Travis CI' \
    && git merge "$PR_commit" --no-ff --no-edit --stat \
    && echo '' >todo.txt \
    && git add -A . \
    && git commit -m "Close PR #$TRAVIS_PULL_REQUEST: successfully applied" \
    && git push origin gh-pages
