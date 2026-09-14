#!/usr/bin/env zsh
#
# zsh-opencode.zsh — Core implementation.
#
# Provides:
#   - PATH setup (only if opencode binary is not already resolvable)
#   - Lazy regeneration of completion file (mtime-based, no --version cost)
#   - Common aliases (curated selection)
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
# Determine the completion file location based on plugin manager context.
_opencode_compfile=""
if [[ -n "${ZSH_COMPDUMP:-}" || -n "${ZIM_HOME:-}" ]]; then
  # Zimfw or generic zsh: completion files must be in fpath to be discovered
  # by compinit. We write next to this file in completions/_opencode.
  _opencode_compfile="${${(%):-%x}:A:h}/completions/_opencode"
elif [[ -n "${ZSH/plugins:-}" || -d "${ZSH:-${HOME}/.oh-my-zsh}/plugins" ]]; then
  # oh-my-zsh: completions live in the plugin dir; compinit auto-discovers.
  _opencode_compfile="${${(%):-%x}:A:h}/completions/_opencode"
else
  # Standalone: use ~/.cache/zsh/ if available, else skip completion.
  _opencode_compfile="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/_opencode"
  [[ -d "${_opencode_compfile:h}" ]] || mkdir -p "${_opencode_compfile:h}"
fi

_opencode_bin="${OPENCODE_BIN:-${HOME}/.opencode/bin}/opencode"
if [[ -x "$_opencode_bin" ]]; then
  # Ensure parent dir exists.
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
