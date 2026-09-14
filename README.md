# zsh-opencode

Plugin/módulo zsh que encapsula aliases y tab completions del CLI de OpenCode. Compatible con Zimfw, oh-my-zsh y standalone.

## Características

- 🚀 **Alto rendimiento**: usa `mtime check` (no `--version`) para invalidación de cache. Costo en shell startup: ~3ms (stat) vs ~600ms (regeneración completa).
- 🎯 **Aliases curados**: 11 aliases de los más útiles (no la lista completa).
- 🔌 **Multi-manager**: estructura idiomática compatible con Zimfw (sin flags), oh-my-zsh y standalone.
- 🪶 **Cero dependencias externas**: sólo requiere el binario `opencode` instalado.

## Estructura del módulo

```
zsh-opencode/
├── LICENSE
├── README.md
├── init.zsh                       # entry point (Zimfw default source)
├── zsh-opencode.plugin.zsh        # shim para oh-my-zsh y standalone
└── functions/
    └── _opencode                  # completion (auto-descubierto vía fpath)
```

## Instalación

### Zimfw (recomendado)

Añadir a `~/.zimrc`, **antes** del módulo `completion`:

```zsh
zmodule c4shdev/zsh-opencode
zmodule completion
```

No requiere flags. Zimfw detecta automáticamente:
- `init.zsh` como entry point (porque `functions/` existe)
- `functions/` para `fpath`
- autoload de las funciones definidas en `functions/`

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

`compinit` de oh-my-zsh añade automáticamente el directorio del plugin a `fpath`, por lo que `_opencode` se descubre vía `functions/`.

### Standalone

```bash
git clone https://github.com/c4shdev/zsh-opencode ~/.local/share/zsh-opencode
```

En `~/.zshrc`, **antes** de `compinit`:

```zsh
fpath=(~/.local/share/zsh-opencode/functions $fpath)
autoload -Uz compinit && compinit
source ~/.local/share/zsh-opencode/zsh-opencode.plugin.zsh
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

## Orden de carga

El módulo **debe** inicializarse **antes** de `compinit`. Esto asegura que la completion regenerada esté disponible cuando `compinit` la lea:

- **Zimfw**: declarar `zmodule c4shdev/zsh-opencode` antes de `zmodule completion`.
- **oh-my-zsh**: el orden de `plugins=(...)` define el orden; `zsh-opencode` debe aparecer antes que cualquier plugin que use completion (prácticamente todos).
- **Standalone**: `source` antes de `compinit`.

## Licencia

MIT
