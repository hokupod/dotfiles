# Path to your oh-my-zsh installation.
export ZSH=/Users/hokuto/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="johndbritton"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby osx bundler brew rails)

## User configuration

# /usr/local/sbin
export PATH="/usr/local/sbin:$PATH"
# history関連
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# BrewFileの場所
export HOMEBREW_BREWFILE=$(brew --prefix)/Library/hokupod_Brewfile/Brewfile
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# byobu
export BYOBU_PREFIX=/usr/local
# neovim の設定ファイル場所
export XDG_CONFIG_HOME=$HOME/.config
# less 環境変数
export LESS='-gj10 --no-init --quit-if-one-screen --RAW-CONTROL-CHARS'
export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

# some more ls aliases
alias ll='ls -alpF --color=auto'
alias la='ls -A'
alias l='ls -CF'
#alias ls='ls -alh --color'
alias crontab='crontab -i'

# vim
alias vi='vim'

# my aliases
alias lt='ls -AltrF'
alias hi='history 1'
alias r=rails
alias g=git
alias rre='rbenv rehash'
alias be='bundle exec'
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias ssheuc='TERM=xterm cocot -t UTF-8 -p EUC-JP ssh '
alias brew-cask-clean-outdated='for c in /usr/local/Caskroom/*; do vl=(`ls -t $c`) && for v in "${vl[@]:1}"; do rm -rf "$c/$v"; done; done'
alias brew-cask-update='for c in `brew cask list`; do ! brew cask info $c | grep -qF "Not installed" || brew cask install $c; done'
alias killp="ps aux | peco | awk '{print \$2}' | xargs kill -9"
alias jxa="osascript -l JavaScript"
alias type='hash -r && type'

# tmux セッション確認
tmux has-session >/dev/null 2>&1 && if [ -z "${TMUX}" ]; then
    echo '% tmux list-sessions'
    tmux list-sessions
    echo '% tmux list-windows -a'
    tmux list-windows -a
fi

# ssh 後に即 tmux
function sshmux(){
  if [ -n "$1" ]; then
      ssh -t $* "tmux -2u attach -d || tmux -2u"
  else
      echo "$0: missing hostname"
      return 1
  fi
}
# ssh の補完を sshmux でも
compdef sshmux=ssh

# rbenv & phpenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init - zsh)"

# retter settings
export EDITOR=vim
export RETTER_HOME=`pwd`/my_letter

# keybind(vim解除)
bindkey -e

# Added by the MacVim
export PATH="/Applications/MacVim.app/Contents/MacOS:$PATH"
# Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# AWS RDSCli
export EC2_REGION=ap-northeast-1
export EC2_URL=https://ec2.ap-northeast-1.amazonaws.com
export AWS_RDS_HOME=/Users/hokuto/aws/RDSCli/RDSCli-1.19.002
export PATH=$PATH:$AWS_RDS_HOME/bin
export AWS_CREDENTIAL_FILE=/Users/hokuto/aws/RDSCli/cred.txt

# Java JDK
export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home

### cool-peco
source $HOME/cool-peco/cool-peco

### golang
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

### coreutils
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
eval $(/usr/local/bin/gdircolors $HOME/.dircolors-solarized/dircolors.256dark)

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim="nvim"
alias zshconf="vim ~/.zshrc"
alias vimconf="vim ~/.vimrc"
alias gvimconf="vim ~/.gvimrc"
alias nvimconf="nvim ~/.config/nvim/init.vim"
alias ideavimconf="vim ~/.ideavimrc"
alias sshconf="vim ~/.ssh/config"
alias dnscacheclear="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say flushed"

## clamav
alias clamscan_all="freshclam && clamscan --infected --exclude-dir='^/dev/|^/Volumes/' --exclude='\.vmdk$|\.vdi$|\.vmwarevm$|\.vmem$' -r / | egrep 'FOUND$' | tee ~/Desktop/clamscan.log"

## vim 文字コード指定
alias vim-utf8='vim -c ":e ++enc=utf8"'
alias vim-sjis='vim -c ":e ++enc=shift_jis"'
alias vim-euc-jp='vim -c ":e ++enc=euc-jp"'
## view 文字コード指定
alias view-utf8='view -c ":e ++enc=utf8"'
alias view-sjis='view -c ":e ++enc=shift_jis"'
alias view-euc-jp='view -c ":e ++enc=euc-jp"'

## cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

# peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | awk '!a[$0]++' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^u' peco-cdr

function peco-cat () {
    if [ ! -z "$1" ] ; then
        cat "$1" | peco
    fi
}

function peco-find-file() {
    if git rev-parse 2> /dev/null; then
        source_files=$(git ls-files)
    else
        source_files=$(find . -type f)
    fi
    selected_files=$(echo $source_files | peco --prompt "[find file]")

    result=''
    for file in $selected_files; do
        result="${result}$(echo $file | tr '\n' ' ')"
    done

    BUFFER="${BUFFER}${result}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-find-file
bindkey '^q' peco-find-file

function gpa () {
    git add .;
    git commit -m $1;
    git push;
}

function mkcd () {
    mkdir $1;
    cd $1;
}

function cdll () {
    cd $1;
    ll;
}

# アクティブのFinderで開いているフォルダに移動
function cdf () {
  target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
  if [ "$target" != "" ]; then
    cd "$target"; pwd
  else
    echo 'No Finder window found' >&2
  fi
}

# Finderで開く
function f () {
  if [ -n "$1" ]; then
    open $1;
  else
    open .;
  fi
}

# カレントパス以下のディレクトリでGrepマッチしたディレクトリに移動
function jj () {
    if [ $1 ]; then
        JUMPDIR=$(find . -type d -maxdepth 1 | grep $1 | tail -1)
        if [[ -d $JUMPDIR && -n $JUMPDIR ]]; then
            cd $JUMPDIR
        else
            echo "directory not found"
        fi
    fi
}

chpwd() {
    ls_abbrev
}
ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}
