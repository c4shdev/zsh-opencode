#!/usr/bin/env zsh
#
# init.zsh — Core implementation (Zimfw default source).
#
# Provides:
#   - PATH setup (only if opencode binary is not already resolvable)
#   - Lazy regeneration of completion file (mtime-based, no --version cost)
#   - Common aliases (curated selection)
#
# This file is auto-sourced by Zimfw because the module has a `functions/`
# subdirectory; see https://zimfw.github.io/docs/ for the default detection
# rules. oh-my-zsh and standalone users get the same behavior via the
# `zsh-opencode.plugin.zsh` shim that sources this file.
#
# Performance notes:
#   - Uses `[[ bin -nt cache ]]` (mtime check) instead of `$(bin --version)`
#     to avoid the ~600ms cost of invoking opencode on every shell start.
#   - Completion regeneration is lazy: first shell start pays the cost of
#     `opencode completion zsh` (~600ms), subsequent shells use the cache.
#   - Aliases are gated with `command -v` to avoid defining them when
#     the binary is missing.
#

# --- 1. PATH setup (only if needed) ---
# Priority: $OPENCODE_BIN env > ~/.opencode/bin (Anthropic default) > skip if already in PATH
if ! command -v opencode &>/dev/null; then
  _opencode_bin_dir="${OPENCODE_BIN:-${HOME}/.opencode/bin}"
  if [[ -d "$_opencode_bin_dir" && ":$PATH:" != *":${_opencode_bin_dir}:"* ]]; then
    path=("$_opencode_bin_dir" $path)
  fi
  unset _opencode_bin_dir
fi

# --- 2. Lazy completion regeneration ---
# Resolves to <module-root>/functions/_opencode. This path is in fpath when
# the module is installed via Zimfw (fpath defaults to `functions/`) or
# oh-my-zsh (plugin dir auto-added to fpath by compinit). For standalone
# usage, the user must add `<module-root>/functions` to fpath before compinit.
_opencode_compfile="${${(%):-%x}:A:h}/functions/_opencode"
_opencode_bin="${OPENCODE_BIN:-${HOME}/.opencode/bin}/opencode"
if [[ -x "$_opencode_bin" ]]; then
  # Ensure parent dir exists (always true here, kept for symmetry with the
  # standalone-cache fallback below).
  [[ -d "${_opencode_compfile:h}" ]] || mkdir -p "${_opencode_compfile:h}"
  # mtime-based invalidation: regenerate ONLY when binary is newer than cache.
  if [[ ! -f "$_opencode_compfile" || "$_opencode_bin" -nt "$_opencode_compfile" ]]; then
    "$_opencode_bin" completion zsh >! "$_opencode_compfile" 2>/dev/null
  fi
fi
unset _opencode_bin _opencode_compfile

# --- 3. Aliases (curated, gated) ---
command -v opencode &>/dev/null && {
  alias oc='opencode'              # base
  alias ocr='opencode run'         # ejecución no-interactiva
  alias ocw='opencode web'         # UI web
  alias ocs='opencode serve'       # server headless
  alias oca='opencode attach'      # TUI ↔ server
  alias ocu='opencode upgrade'     # binario actualiza seguido
  alias ocm='opencode models'      # listar modelos
  alias ocst='opencode stats'      # tokens/coste
  alias ocp='opencode providers'   # auth/proveedores
  alias ocpr='opencode pr'         # flujo de PR
  alias ocses='opencode session'   # gestión de sesiones
}
