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
- [x] Add will suggest packages from cache
- [x] Remove will suggest package from current package.json file
- [x] Upgrade | Upgrade-interactive will suggest packages from package.json file
- [x] Workspace will suggest workspaces names from workspaces info 
- [ ] Workspace after workspace name will suggest commands and scripts
- [x] Yarn (empty) will suggest available commands and scripts from package.json
- [x] Run will suggest scripts from package.json and [ env ]
- [ ] Global will suggest [ add | bin | dir | list | remove | upgrade | upgrade-interactive ]
- [x] Workspaces will suggest [ run | list ]
- [ ] Workspaces run will suggest scripts from package.json files in workspaces
- [ ] Cache will suggest [ list (—pattern) | dir | clean ]
- [ ] Config suggests [ set | get | delete | list ]
- [ ] Config set | get maybe suggest config keys
- [ ] Help suggests all commands excepts global strictly
- [ ] Info suggests packages from cache
- [ ] Licences suggests [ list | generate-disclaimer ]
- [ ] Owner suggests [ list | add | remove ]
- [ ] Policies suggests [ set-version ]
- [ ] Tag suggests [ add | remove | list ]
- [ ] Team suggests [ create | destroy | add | remove | list ]
 
## Contribution
> Any contribution are welcome

## License
MIT

## Acknowledgments 
[zsh-better-npm-completion](https://github.com/lukechilds/zsh-better-npm-completion) — used few function from project and helped understand how to write proper autocompletion system for zsh.
