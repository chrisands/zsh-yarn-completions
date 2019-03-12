# zsh yarn completions
> Yarn completions for Z-shell that supports `yarn workspaces`

## What is does?
- Right now not much 😅

## Requirements:
  - [zsh](https://github.com/zsh-users/zsh) - `Z-shell`
  - [jq](https://stedolan.github.io/jq/) - `JSON processor`

## Installation
> describe how to install

## Roadmap
- [x] `add` will suggest packages from cache
- [x] `remove` will suggest package from current package.json file
- [x] `upgrade` | `upgrade-interactive` will suggest packages from package.json file
- [x] `workspace` will suggest workspaces names from workspaces info 
- [x] `workspace` after workspace name will suggest commands and scripts
- [ ] add completions to `workspace` commands
- [x] `yarn` (empty) will suggest available commands and scripts from package.json
- [x] `run` will suggest scripts from package.json and [ `env` ]
- [ ] `global` will suggest [ `add` | `bin` | `dir` | `list` | `remove` | `upgrade` | `upgrade-interactive` ]
- [x] `workspaces` will suggest [ `run` | `list` ]
- [ ] `workspaces` run will suggest scripts from package.json files in workspaces
- [ ] `cache` will suggest [ `list` *(—pattern)* | `dir` | `clean` ]
- [ ] `config` suggests [ `set` | `get` | `delete` | `list` ]
- [ ] `config` `set` | `get` maybe suggest config keys
- [ ] `help` suggests all commands excepts global strictly
- [ ] `info` suggests packages from cache
- [ ] `licences` suggests [ `list` | `generate-disclaimer` ]
- [ ] `owner` suggests [ `list` | `add` | `remove` ]
- [ ] `policies` suggests [ `set-version` ]
- [ ] `tag` suggests [ `add` | `remove` | `list` ]
- [ ] `team` suggests [ `create` | `destroy` | `add` | `remove` | `list` ]
 
## Contribution
> Any contribution are welcome

## License
MIT

## Acknowledgments 
[zsh-better-npm-completion](https://github.com/lukechilds/zsh-better-npm-completion) — used few function from project and helped understand how to write proper autocompletion system for zsh.
