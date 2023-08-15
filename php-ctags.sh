#!/bin/bash

# Simple script to build moodle ctags (required MacPort's ctags to be installed)
# Note this uses the patched ctags: https://sourceforge.net/p/ctags/patches/83/

# List of default directories (absolute paths) that will be processed
defaultdirs="/users/stronk7/git_moodle/moodle
      /users/stronk7/git_moodle/integration
      /users/stronk7/git_moodle/testing
      /users/stronk7/git_moodle/survey
      /users/stronk7/git_moodle/mediawiki"

dirs="${1:-${defaultdirs}}"

for dir in $dirs
do
    echo "processing $dir";
    cd $dir
    $HOME/bin/ctags -R --languages=php \
        --exclude="CVS" \
        --exclude=".git" \
        --exclude="vendor" \
        --exclude="node_modules" \
        --fields=+aimS \
        --php-kinds=cdfint \
        --tag-relative=yes \
        --totals=yes
done