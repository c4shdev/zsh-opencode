# zsh-opencode

Plugin/módulo para integrar el CLI de OpenCode en zsh. Compatible con Zimfw, oh-my-zsh y standalone.

## Características

- 🚀 **Alto rendimiento**: usa `mtime check` (no `--version`) para invalidación de cache. Costo en shell startup: ~3ms (stat) vs ~600ms (regeneración completa).
- 🎯 **Aliases curados**: 11 aliases de los más útiles (no la lista completa).
- 🔌 **Multi-manager**: compatible con Zimfw, oh-my-zsh y standalone.
- 🪶 **Cero dependencias externas**: sólo requiere el binario `opencode` instalado.

## Instalación

### Zimfw

Añadir a `~/.zimrc`:

```zsh
zmodule c4shdev/zsh-opencode --fpath completions
```

Luego:

```bash
zimfw build
exec zsh
```

### oh-my-zsh

Clonar como plugin:

```bash
git clone https://github.com/c4shdev/zsh-opencode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-opencode
```

Añadir a `~/.zshrc`:

```zsh
plugins=(... zsh-opencode)
```

### Standalone

```bash
git clone https://github.com/c4shdev/zsh-opencode ~/.local/share/zsh-opencode
echo 'source ~/.local/share/zsh-opencode/zsh-opencode.plugin.zsh' >> ~/.zshrc
```

## Aliases

| Alias | Comando |
|---|---|
| `oc` | `opencode` |
| `ocr` | `opencode run` |
| `ocw` | `opencode web` |
| `ocs` | `opencode serve` |
| `oca` | `opencode attach` |
| `ocu` | `opencode upgrade` |
| `ocm` | `opencode models` |
| `ocst` | `opencode stats` |
| `ocp` | `opencode providers` |
| `ocpr` | `opencode pr` |
| `ocses` | `opencode session` |

## Configuración

- `$OPENCODE_BIN`: directorio del binario `opencode`. Default: `~/.opencode/bin`.

## Cómo funciona la completion lazy

1. Primer shell start: el módulo genera `_opencode` ejecutando `opencode completion zsh` (~600ms una vez).
2. Shells subsiguientes: comparamos `mtime` del binario vs el cache. Si el binario no cambió, no se regenera.
3. Cuando actualizas opencode (`ocu` o `brew upgrade`): el binario es más nuevo que el cache, se regenera.

## Licencia

MIT
