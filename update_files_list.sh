#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function upd () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  set -o pipefail -o errexit
  cd -- "$SELFPATH"

  local FEXTS="$(grep -oPe '^\*\.\w+(?= \S)' -- .gitattributes)"
  FEXTS="${FEXTS//'*.'/}"
  FEXTS="${FEXTS//$'\n'/|}"

  exec < <(exec git ls-files)
  exec < <(exec grep -Pe '^\S+\.'"($FEXTS)")
  exec < <(exec sort --version-sort)
  exec < <(exec sed -re 's:^\S+$:* [`&`](\r&\r):')
  exec < <(exec sed -re 's|\r(\S+\.dae\.gz)\r\)|& \&middot; [view]('$(
    )'../webspectator3d-collada/view.html?sceneFile='$(
    )'../webspectator3d-examples/\1)|')
  exec < <(exec sed -re 's:\r::g')

  local SED='^<!-- _ files list -->$'
  SED="/${SED/_/BEGIN}/,/${SED/_/ENDOF}/"
  SED+=$'{/^<!-- /!d\n/^<!-- BEGIN /r/dev/stdin\n}'
  sed -rf <(echo "$SED") -i -- README.md
  git diff HEAD -- README.md
}










upd "$@"; exit $?
