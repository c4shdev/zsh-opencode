#!/usr/bin/env zsh
# init.zsh — core (Zimfw auto-source; omz/standalone via .plugin.zsh).

if ! command -v opencode &>/dev/null; then
  _opencode_bin_dir="${OPENCODE_BIN:-${HOME}/.opencode/bin}"
  if [[ -d "$_opencode_bin_dir" && ":$PATH:" != *":${_opencode_bin_dir}:"* ]]; then
    path=("$_opencode_bin_dir" $path)
  fi
  unset _opencode_bin_dir
fi

# mtime check avoids invoking `opencode --version` (~600ms) on every shell start.
_opencode_compfile="${${(%):-%x}:A:h}/functions/_opencode"
_opencode_bin="${OPENCODE_BIN:-${HOME}/.opencode/bin}/opencode"
if [[ -x "$_opencode_bin" ]]; then
  [[ -d "${_opencode_compfile:h}" ]] || mkdir -p "${_opencode_compfile:h}"
  if [[ ! -f "$_opencode_compfile" || "$_opencode_bin" -nt "$_opencode_compfile" ]]; then
    "$_opencode_bin" completion zsh >! "$_opencode_compfile" 2>/dev/null
  fi
fi
unset _opencode_bin _opencode_compfile

command -v opencode &>/dev/null && {
  alias oc='opencode'
  alias ocr='opencode run'
  alias ocw='opencode web'
  alias ocs='opencode serve'
  alias oca='opencode attach'
  alias ocu='opencode upgrade'
  alias ocm='opencode models'
  alias ocst='opencode stats'
  alias ocp='opencode providers'
  alias ocpr='opencode pr'
  alias ocses='opencode session'
}
