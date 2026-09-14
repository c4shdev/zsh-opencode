#!/usr/bin/env zsh
#
# Shim for oh-my-zsh and standalone. Zimfw sources init.zsh directly.
# Standalone users must add functions/ to fpath before compinit:
#     fpath=(~/path/to/zsh-opencode/functions $fpath)
#     source ~/path/to/zsh-opencode/zsh-opencode.plugin.zsh

source "${0:A:h}/init.zsh"
