_yarn_recursively_look_for() {
  local filename="$1"
  local workspace="$2" # if there are workspace use this instead dir
  local dir=$PWD
  while [ ! -e "$dir/$filename" ]; do
    dir=${dir%/*}
    [[ "$dir" = "" ]] && break
  done
  [[ ! "$dir" = "" ]] && echo "$dir/$filename"
}

_yarn_get_workspaces() { # add condition if pwd is not yarn workspace
  local -a workspaces

  for workspace in $(
    yarn workspaces info |
    sed '1d;$d' |
    jq keys |
    jq -r '.[]'
  ); do
    workspaces+=($workspace)
  done

  # locations=$(
  #   yarn workspaces info |
  #   sed '1d;$d' |
  #   jq -c '.[].location'
  # )

  _describe -t workspace-names 'workspaces names' workspaces
  #echo $PWD/$locations[1]/package.json
}

_yarn_get_package_json_property_object() {
  local package_json="$1"
  local property="$2"
  cat "$package_json" |
    sed -nE "/^  \"$property\": \{$/,/^  \},?$/p" | # Grab scripts object
    sed '1d;$d' |                                   # Remove first/last lines
    sed -E 's/    "([^"]+)": "(.+)",?/\1=>\2/'      # Parse into key=>value
}

_yarn_get_package_json_property_object_keys() {
  local package_json="$1"
  local property="$2"
  _yarn_get_package_json_property_object "$package_json" "$property" | cut -f 1 -d "="
}

_yarn_parse_package_json_for_script_suggestions() {
  local package_json="$1"
  _yarn_get_package_json_property_object "$package_json" scripts |
    sed -E 's/(.+)=>(.+)/\1:$ \2/' |  # Parse commands into suggestions
    sed 's/\(:\)[^$]/\\&/g' |         # Escape ":" in commands
    sed 's/\(:\)$[^ ]/\\&/g'          # Escape ":$" without a space in commands
}

_yarn_parse_package_json_for_deps() {
  local package_json="$1"
  _yarn_get_package_json_property_object_keys "$package_json" dependencies
  _yarn_get_package_json_property_object_keys "$package_json" devDependencies
}

_yarn_get_scripts_from_package_json() {
  local package_json="$(_yarn_recursively_look_for package.json)"

  [[ "$package_json" = "" ]] && return

  local -a options
  options=(
    ${(f)"$(_yarn_parse_package_json_for_script_suggestions $package_json)"} \
    env:'Prints list of environment variables available to the scripts at runtime' \
  )

  _describe -t package-scripts 'package scripts' options
}

_yarn_get_packages_from_package_json() {
  local package_json="$(_yarn_recursively_look_for package.json)"

  # Return if we can't find package.json
  [[ "$package_json" = "" ]] && return

  _values $(_yarn_parse_package_json_for_deps "$package_json")
}

_yarn_get_cached_packages() { # todo: find faster method to get cached packages
  yarn cache list |
  awk '{ print $1 }' |
  sed '1d;2d;$d'
}

_yarn_workspace_commands() {
  echo words $words
  echo state: $state
}

_yarn_common_flags() {
  local -a list
  
  list=(
    --cache-folder:'specify a custom folder that must be used to store the yarn cache]: :_directorie'
    --check-files:'install will verify file tree of packages for consistency'
    --cwd:'working directory to use]: :_directorie'
    --disable-pnp:'disable the Plug'n'Play installation'
    --emoji:'enable emoji in output, by default: true'
    --enable-pnp:'enable the Plug'n'Play installation'
    --pnp:'enable the Plug'n'Play installation'
    --flat:'only allow one version of a package'
    --focus:'Focus on a single workspace by installing remote copies of its sibling workspaces.'
    --force:'install and build packages even if they were built before, overwrite lockfile'
    --frozen-lockfile:'don’t generate a lockfile and fail if an update is needed'
    --global-folder:'specify a custom folder to store global packages'
    --har:'save HAR output of network traffic'
    --https-proxy
    --ignore-engines:'ignore engines check'
    --ignore-optional:'ignore optional dependencies'
    --ignore-platform:'ignore platform checks'
    --ignore-scripts:'don’t run lifecycle scripts'
    --json:'format Yarn log messages as lines of JSON'
    --link-duplicates:'create hardlinks to the repeated modules in node_modules'
    --link-folder:'specify a custom folder to store global links'
    --modules-folder:'rather than installing modules into the node_modules folder relative to the cwd, output them here'
    --mutex:'use a mutex to ensure only one yarn instance is executing'
    --network-concurrency:'maximum number of concurrent network requests'
    --network-timeout:'TCP timeout for network requests'
    --no-bin-links:'don’t generate bin links when setting up packages'
    --no-default-rc:'prevent Yarn from automatically detecting yarnrc and npmrc files'
    --no-lockfile:'don’t read or generate a lockfile'
    --non-interactive:'do not show interactive prompts'
    --no-node-version-check:'do not warn when using a potentially unsupported Node version'
    --no-progress:'disable progress bar'
    --offline:'trigger an error if any required dependencies are not available in local cache'
    --otp:'one-time password for two factor authentication'
    --prefer-offline:'use network only if dependencies are not available in local cache'
    --preferred-cache-folder:'specify a custom folder to store the yarn cache if possible'
    --prod:'prod'
    --production:'prod'
    --proxy
    --pure-lockfile:'don’t generate a lockfile'
    --registry:'override configuration registry'
    -s:'skip Yarn console logs, other types of logs will be printed'
    --silent:'skip Yarn console logs, other types of logs will be printed'
    --scripts-prepend-node-path:'prepend the node executable dir to the PATH in scripts'
    --skip-integrity-check:'run install without checking if node_modules is installed'
    --strict-semver
    --update-checksums:'update package checksums from current repository'
    --use-yarnrc:'specifies a yarnrc file that Yarn should use. not .npmrc'
    -v:'output the version number'
    --version:'output the version number'
    --verbose:'output verbose messages on internal operations'
    -h:'output usage information'
    --help:'output usage information'
  )

  _describe -t common-flags 'common flags' list
}

_yarn_global_commands() {
  local -a list

  list=(
    add:'Installs a package and any packages that it depends on.'
    bin:'Displays the location of the yarn bin folder.'
    list:'List installed packages.'
    remove:'Remove the package updayarn ting your package.json and yarn.lock files in the process.'
    upgrade:'Upgrades packages to their latest version based on the specified range.'
    upgrade-interactive:'Upgrades packages interactively.'
  )

  _describe -t global-commands 'global commands' list
}

_yarn_global_strictly_commands() {
  local -a list

  list=(
    dir:'Prints the output of the global installation folder.'
  )

  _describe -t global-strictly-commands 'global strictly commands' list
}

_yarn_common_commands() {
  local -a list

  list=(
    audit:'Perform a vulnerability audit against the installed packages.'
    autoclean:'Cleans and removes unnecessary files from package dependencies.'
    cache:'Yarn stores every package in a global cache in your user directory on the file system.'
    check:'Verifies that versions of the package dependencies in the current project’s package.json match those in yarn’s lock file.'
    config:'Manages the yarn configuration files.'
    create:'Creates new projects from any create-* starter kits.'
    generate-lock-entry:'Generates a lock file entry.'
    global:'Installs packages globally on your operating system.'
    help:'Displays help information.'
    import:'Generates yarn.lock from an npm package-lock.json file in the same location or an existing npm-installed node_modules folder.'
    info:'Show information about a package.'
    init:'Interactively creates or updates a package.json file.'
    install:'Install all dependencies for a project.'
    licenses:'List licenses for installed packages.'
    link:'Symlink a package folder during development.'
    login:'Store registry username and email.'
    logout:'Clear registry username and email.'
    outdated:'Checks for outdated package dependencies.'
    owner:'Manage package owners.'
    pack:'Creates a compressed gzip archive of package dependencies.'
    policies:'Defines project-wide policies for your project.'
    publish:'Publishes a package to the npm registry.'
    run:'Runs a defined package script.'
    tag:'Add, remove, or list tags on a package.'
    team:'Maintain team memberships.'
    unlink:'Unlink a previously created symlink for a package.'
    unplug:'Temporarily copies a package (with an optional @range suffix) outside of the global cache for debugging purposes.'
    version:'Updates the package version.'
    versions:'Displays version information of the currently installed Yarn, Node.js, and its dependencies.'
    why:'Show information about why a package is installed.'
    workspace:'This will run the chosen Yarn command in the selected workspace.'
    workspaces:'Show information about your workspaces.'
  )

  _describe -t common-commands 'common commands' list
}

_yarn_completion() {
  local curcontext="$curcontext" state state_descr line
  typeset -A opt_args
  local -a orig_words
  local package_json="$(_yarn_recursively_look_for package.json)"

  orig_words=( ${words[@]} )

  _arguments -C \
    '--cache-folder[specify a custom folder that must be used to store the yarn cache]: :_directories' \
    '--check-files[install will verify file tree of packages for consistency]' \
    '--cwd[working directory to use]: :_directories' \
    '--disable-pnp[disable the Plug'n'Play installation]' \
    '--emoji[enable emoji in output, by default: true]' \
    '--enable-pnp --pnp[enable the Plug'n'Play installation]' \
    '--flat[only allow one version of a package]' \
    '--focus[Focus on a single workspace by installing remote copies of its sibling workspaces.]' \
    '--force[install and build packages even if they were built before, overwrite lockfile]' \
    '--frozen-lockfile[don’t generate a lockfile and fail if an update is needed]' \
    '--global-folder[specify a custom folder to store global packages]' \
    '--har[save HAR output of network traffic]' \
    '--https-proxy' \
    '--ignore-engines[ignore engines check]' \
    '--ignore-optional[ignore optional dependencies]' \
    '--ignore-platform[ignore platform checks]' \
    '--ignore-scripts[don’t run lifecycle scripts]' \
    '--json[format Yarn log messages as lines of JSON]' \
    '--link-duplicates[create hardlinks to the repeated modules in node_modules]' \
    '--link-folder[specify a custom folder to store global links]' \
    '--modules-folder[rather than installing modules into the node_modules folder relative to the cwd, output them here]' \
    '--mutex[use a mutex to ensure only one yarn instance is executing]' \
    '--network-concurrency[maximum number of concurrent network requests]' \
    '--network-timeout[TCP timeout for network requests]' \
    '--no-bin-links[don’t generate bin links when setting up packages]' \
    '--no-default-rc[prevent Yarn from automatically detecting yarnrc and npmrc files]' \
    '--no-lockfile[don’t read or generate a lockfile]' \
    '--non-interactive[do not show interactive prompts]' \
    '--no-node-version-check[do not warn when using a potentially unsupported Node version]' \
    '--no-progress[disable progress bar]' \
    '--offline[trigger an error if any required dependencies are not available in local cache]' \
    '--otp[one-time password for two factor authentication]' \
    '--prefer-offline[use network only if dependencies are not available in local cache]' \
    '--preferred-cache-folder[specify a custom folder to store the yarn cache if possible]' \
    '--prod --production[prod]' \
    '--proxy' \
    '--pure-lockfile[don’t generate a lockfile]' \
    '--registry[override configuration registry]' \
    '-s --silent[skip Yarn console logs, other types of logs will be printed]' \
    '--scripts-prepend-node-path[prepend the node executable dir to the PATH in scripts]' \
    '--skip-integrity-check[run install without checking if node_modules is installed]' \
    '--strict-semver' \
    '--update-checksums[update package checksums from current repository]' \
    '--use-yarnrc[specifies a yarnrc file that Yarn should use. not .npmrc]' \
    '-v --version[output the version number]' \
    '--verbose[output verbose messages on internal operations]' \
    '-h --help[output usage information]' \
		'(-): :->command' \
		'(-)*:: :->arg'

  # echo
  # echo state: $state
  # echo curcontext: $curcontext
  # echo descr: $state_descr
  # echo line: $line
  # echo arg: $0, $1, $2, $3
  # echo words: $words $words[1]
  # echo opt_args: $opt_args
  # echo _ret $_ret
  # echo _default $_default
  # echo service $service
  # echo CURRENT $CURRENT
  # echo last word: $words[-1]
  # echo

  case $state in
    command)
      _alternative \
        'global-commands:global:_yarn_global_commands' \
        'common-commands:common:_yarn_common_commands' \
        'package-scripts:scripts:_yarn_get_scripts_from_package_json' \
    ;;
    arg)
      if [[ "$words[-1]" == "-" ]]; then
        _yarn_common_flags \
        && return
      fi

      case $words[1] in
        add)
          _values $(_yarn_get_cached_packages) \
        ;;
        remove)
          _yarn_get_packages_from_package_json \
        ;;
        upgrade | upgrade-interactive)
          _yarn_get_packages_from_package_json \
        ;;
        run)
          [[ $CURRENT == 3 ]] && return
          _yarn_get_scripts_from_package_json
        ;;
        global)
          echo global
        ;;
        workspaces)
          [[ $CURRENT == 3 ]] && return
          local -a list 

          list=(
            info:'Display the workspace dependency tree of your current project.'
            run:'Run the chosen Yarn command in each workspace.'
          )

          _describe -t workspaces-commands 'workspaces commands' list
        ;;
        workspace)
          [[ $CURRENT -gt 2 ]] && \
          _yarn_workspace_commands && \
          return # if current == 3 then run commands like useal 'yarn'

          _yarn_get_workspaces
        ;;
      esac
    ;;
  esac

}

compdef _yarn_completion yarn