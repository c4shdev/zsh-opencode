#!/usr/bin/env zsh
#
# zsh-opencode.plugin.zsh — Universal entry point.
#
# Compatible con:
#   - Zimfw (clonado a ~/.zim/modules/zsh-opencode/)
#   - oh-my-zsh (como plugin de la lista `plugins`)
#   - Standalone (source directo en .zshrc o .zprofile)
#
# Detecta el contexto y delega al archivo de implementación.
#

# Resolver el directorio del módulo de forma portable.
# ${0:A:h} funciona en sourcing desde archivo; fallback a $funcstack para omz.
_opencode_plugin_dir="${${(%):-%x}:A:h}"
if [[ ! -d "$_opencode_plugin_dir" ]]; then
  # Fallback para contextos donde ${(%):-%x} no resuelve (ej. eval)
  _opencode_plugin_dir="${ZSH_PLUGINS_DIR:-${ZDOTDIR:-${HOME}/.config/zsh}/modules/zsh-opencode}"
fi

# Source de la implementación principal si existe.
if [[ -f "${_opencode_plugin_dir}/zsh-opencode.zsh" ]]; then
  source "${_opencode_plugin_dir}/zsh-opencode.zsh"
fi

unset _opencode_plugin_dir
