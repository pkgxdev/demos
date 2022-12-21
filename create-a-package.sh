#!/bin/bash

set -e

if ! which -s tea; then
  echo "re-run with tea: https://github.com/teaxyz/cli" >&2
  exit 1
fi

if ! which -s git; then
  #TODO obviously installing with `tea` is what we should do here
  echo "no git found" >&2
  exit 1
fi


tea +charm.sh/gum gum format --<<EOMD
# bootstrap the requirements for building a package

## what to expect from this script

* installs \`gh\` using \`tea\`
* clones \`cli\`, \`pantry.core\` repositories
* forks \`pantry.extra\`
* adds \`GITHUB_TOKEN\` to env
* adds \`TEA_PANTRY_PATH\` to env
EOMD

tea +charm.sh/gum gum confirm "shall we continue?"

tea +cli.github.com which -s gh

# import env so we don’t need to use `tea` to use `gum` or `gh`
source <(tea --dump +charm.sh/gum +cli.github.com)

gum format "k first up, we’ll configure your project root dir"

# FIXME: escape properly if dir already exists
projectpath=$(gum input --prompt "where do you want to install it? " --value="$HOME/")

mkdir $projectpath/pkgdev
cd $projectpath/pkgdev

gum format "next, we’ll clone the required repositories: \`cli\`, \`pantry.core\`, and fork of \`pantry.extra\`."
gum confirm "shall we continue?"


gh repo clone teaxyz/cli
gh repo clone teaxyz/pantry.core
gh repo fork teaxyz/pantry.extra --clone=true


gum format "finally, we’ll setup your package directory with a minimal \`package.yml\` to get started"

packagename=$(gum input --prompt "what is the name of your package? ")

cd pantry.extra
tea +git-scm.org git checkout -b $packagename
cd ..

mkdir pantry.extra/projects/$packagename

# minimal package.yml structure
tea +gnu.org/wget wget -O pantry.extra/projects/$packagename/package.yml https://gist.githubusercontent.com/mfts/b1fb45cb7df9e3691d9c6fd65cf790c3/raw/e86e04c878eeae06ea0eaf5afebf92378d49c266/package.yml

gum format <<EOMD
# done!
You are ready to start packaging $packagename

0. cd \`$projectpath/pkgdev\`
1. edit \`pantry.extra/projects/$packagename/package.yml\`
2. make sure the builds are working with
    \`TEA_PANTRY_PATH="$projectpath/pkgdev/pantry.extra" pantry.core/scripts/build.ts $packagename\`

note: we have already checked out a new branch in \`pantry.extra\` with the name "$packagename"

check out the \`wiki\` for my information about packaging for \`tea\`
> https://github.com/teaxyz/pantry.zero/wiki
EOMD

