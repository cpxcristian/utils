# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
HISTSIZE=10000
SAVEHIST=10000

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias py='python3'

prompt_dir() {
  prompt_segment blue black '%2~'
}

switch-php() {
    if [ ! -f "/usr/bin/php$1" ]; then
        echo "Error: PHP $1 no está instalado. Instálalo con: sudo apt install php$1"
        return 1
    fi

    echo "Cambiando a PHP $1..."
    sudo update-alternatives --set php /usr/bin/php$1 >/dev/null 2>&1
    if [ -f "/usr/bin/phar$1" ]; then
        sudo update-alternatives --set phar /usr/bin/phar$1 >/dev/null 2>&1
    fi

    local active_mods=$(a2query -m | grep -E '^php[0-9.]+' | awk '{print $1}')

    if [ ! -z "$active_mods" ]; then
        for mod in $active_mods; do
            sudo a2dismod $mod >/dev/null 2>&1
        done
    fi

    sudo a2enmod php$1
    sudo systemctl restart apache2

    hash -r

    echo "¡Listo! Versión actual:"
    php -v
}

install-php-version() {
    sudo apt install php$1 php$1-common php$1-cli php$1-curl php$1-mbstring php$1-mysql php$1-xml php$1-zip
    switch-php $1
}

import-dump() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Faltan argumentos."
        echo "Uso: import_dump <archivo_dump.sql> <nombre_base_datos>"
        return 1
    fi

    local DUMP_FILE="$1"
    local DB_NAME="$2"

    if [ ! -f "$DUMP_FILE" ]; then
        echo "Error: El archivo '$DUMP_FILE' no existe."
        return 1
    fi

    if mariadb -u root -p -e "DROP DATABASE IF EXISTS \`$DB_NAME\`; CREATE DATABASE \`$DB_NAME\`;"; then
        echo "Importando dump..."
        mariadb --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;" -u root -p "$DB_NAME" < "$DUMP_FILE"
        echo "¡Éxito! El dump se ha importado correctamente."
    fi
}

sync-back() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Error. Faltan parámetros: sync-pos3-back <user@server> <directorio_remoto>"
        return 1
    fi
    ionice -c 3 rsync -rtv --size-only --inplace --bwlimit=10m -e 'ssh -p 19222' build/ $1:/var/www/html/$2/
}
sync-front() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Error. Faltan parámetros: sync-pos3-front <user@server> <directorio_remoto>"
        return 1
    fi

    local excludes=('.env' '.next/cache' '.next/dev/' '.git' 'node_modules')

    local exclude_args=()
    for item in "${excludes[@]}"; do
        exclude_args+=(--exclude="$item")
    done

    ionice -c 3 rsync -rtv --checksum --inplace --delete --bwlimit=10m "${exclude_args[@]}" -e 'ssh -p 19222' . $1:/var/www/html/$2/
}
sync-pos3-back() {
    sync-back copixil@40.124.89.212 $1
}
sync-pos3-front() {
    sync-front copixil@40.124.89.212 $1
}
sync-gelow-back() {
    sync-back copixil@40.124.105.27 $1
}
sync-gelow-front() {
    sync-front copixil@40.124.105.27 $1
}
sync-gelow-pos() {
    if [ -z "$1" ]; then
        echo "❌ Error. Faltan parámetros: sync-gelow-pos <sucursal>"
        return 1
    fi

    local excludes=('.env' '.vscode' '.git' 'node_modules' 'storage')

    local exclude_args=()
    for item in "${excludes[@]}"; do
        exclude_args+=(--exclude="$item")
    done

    ionice -c 3 rsync -rtv --checksum --inplace --delete --bwlimit=10m "${exclude_args[@]}" -e 'ssh -p 19222' . copixil@40.124.105.27:/var/www/html/$1/
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


export PATH="$PATH:/opt/android-studio-for-platform/bin"