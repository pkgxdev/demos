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
# simple setup for git GPG
*signing your commits is important for the security of the entire software industry, both open and closed.*

## what to expect from this script

* installs \`withoutboats/bpb\`† using \`tea\`
* add its binary to your \`PATH\`
* configures \`git\` to use it
* help you add your GPG key to GitHub

> † \`bpb\` is a much simpler way to sign your commits than using GnuGPG
> https://github.com/withoutboats/bpb
EOMD

tea +charm.sh/gum gum confirm "shall we continue?"

tea +crates.io/bpb which -s bpb

if ! test -f ~/.bpb_keys.toml; then
  #TODO probably we should ask `git` first

  tea +charm.sh/gum gum format "k first up, we’ll configure your GPG key"

  user=$(tea +charm.sh/gum gum input --prompt "what’s your name? ")
  email=$(tea +charm.sh/gum gum input --prompt "what’s your email? ")
  tea +crates.io/bpb bpb init "$user <$email>"

  GENERATED_KEY=1
else
  GENERATED_KEY=0
fi

#TODO if there’s an XDG_HOME or something, use that
if ! test -f /usr/local/bin/tea_bpb; then
  if tea +charm.sh/gum gum confirm "shall we add \`bpb\` to \`/usr/local/bin\`?"; then
    sudo ln -s ~/.tea/tea.xyz/v\*/bin/tea /usr/local/bin/tea_bpb
  else
    tea +charm.sh/gum gum format "k, you’ll need to add \`tea_bpb\` to your \`PATH\` yourself"
  fi
fi

git config --global gpg.program tea_bpb

if (($GENERATED_KEY)); then
  middle=<<EOMD
your GPG key was generated into ~/.bpb_keys.toml
now add your gpg key to your account:
> https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
EOMD
else
  middle="\`bpb\` was already configured with a GPG key"
fi


if tea +charm.sh/gum gum confirm -f "shall we add \`bpb\` to \`your github account\`?"; then
  tea +charm.sh/gum gum format "first, we need to refresh your github with \`write:gpg_key\` scope."
  # authenticate with gh on web with https and extra permission to write gpg_key
  tea +github.com/cli/cli gh auth login -h github.com -p https -s write:gpg_key -w
  # pipe bpb public key to gh
  tea_bpb print | tea +github.com/cli/cli gh gpg-key add -
else
  tea +charm.sh/gum gum format --<<EOMD
    k, just add your gpg key to your github account by yourself: 
    > https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account
EOMD
fi

tea +charm.sh/gum gum format <<EOMD
# done!
$middle

check out the \`bpb\` README for my information about \`bpb\`
> https://github.com/withoutboats/bpb

# help improve this script!
* allow it to port an existing GnuGPG key over
* support for other coding hubs
EOMD

echo  # spacer
