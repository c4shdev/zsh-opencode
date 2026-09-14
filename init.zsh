#!/usr/bin/env zsh
#
# init.zsh — Core implementation. Auto-sourced by Zimfw (default source
# when functions/ exists). oh-my-zsh and standalone users reach it via
# zsh-opencode.plugin.zsh.

# --- PATH setup ---
if ! command -v opencode &>/dev/null; then
  _opencode_bin_dir="${OPENCODE_BIN:-${HOME}/.opencode/bin}"
  if [[ -d "$_opencode_bin_dir" && ":$PATH:" != *":${_opencode_bin_dir}:"* ]]; then
    path=("$_opencode_bin_dir" $path)
  fi
  unset _opencode_bin_dir
fi

# --- Lazy completion regeneration ---
# mtime check (bin -nt cache) avoids the ~600ms cost of `opencode --version`
# on every shell start. Cache path is <module-root>/functions/_opencode.
_opencode_compfile="${${(%):-%x}:A:h}/functions/_opencode"
_opencode_bin="${OPENCODE_BIN:-${HOME}/.opencode/bin}/opencode"
if [[ -x "$_opencode_bin" ]]; then
  [[ -d "${_opencode_compfile:h}" ]] || mkdir -p "${_opencode_compfile:h}"
  if [[ ! -f "$_opencode_compfile" || "$_opencode_bin" -nt "$_opencode_compfile" ]]; then
    "$_opencode_bin" completion zsh >! "$_opencode_compfile" 2>/dev/null
  fi
fi
unset _opencode_bin _opencode_compfile

# --- Aliases ---
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
