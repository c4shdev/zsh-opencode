#!/usr/bin/env zsh
#
# zsh-opencode.plugin.zsh — Shim for oh-my-zsh and standalone usage.
#
# Zimfw auto-detects `init.zsh` as the entry point when `functions/` exists,
# so this file is NOT used by Zimfw (see https://zimfw.github.io/docs/).
#
# oh-my-zsh looks for `<name>.plugin.zsh` in the plugin dir and `compinit`
# auto-adds the plugin dir to fpath, so `_opencode` is found under `functions/`.
#
# Standalone users must add `<module>/functions` to fpath BEFORE compinit:
#
#     fpath=(~/path/to/zsh-opencode/functions $fpath)
#     autoload -Uz compinit && compinit
#     source ~/path/to/zsh-opencode/zsh-opencode.plugin.zsh
#

source "${0:A:h}/init.zsh"
