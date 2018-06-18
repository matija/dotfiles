if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
    . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh ]; then
    . /opt/local/share/doc/git-core/contrib/completion/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
source ~/.git-completion.bash

export ARCHFLAGS="-arch x86_64"
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export HOMEBREW_NO_GITHUB_API="1"
export HOMEBREW_NO_ANALYTICS="1"

export BITS_AWS_BUCKET="bits.kodius.io"
alias be="bundle exec"
alias pgstart="pg_ctl -D /usr/local/var/postgresql@9.5 start"
alias pgstop="pg_ctl -D /usr/local/var/postgresql@9.5 stop"
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias rbserver='ruby -run -e httpd . -p 9090'
export GREP_OPTIONS='--color=auto'
export GHOST_NODE_VERSION_CHECK=false
export CLICOLOR=1

if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi

export NODE_BIN='node'
export NODE_PATH='/app/node_modules'
alias ngrok='~/bin/ngrok http'
alias deis='~/bin/deis'
alias fasd='~/bin/fasd'
set -o vi

eval "$(rbenv init -)"
eval "$(fasd --init auto)"

export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/opt/postgresql@9.5/bin:$PATH"
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"
export MYSQL_HOME="/usr/local/mysql-5.6.39-macos10.13-x86_64"
export PATH="${MYSQL_HOME}/bin:$PATH"
export PATH="/Applications/LibreOffice.app/Contents/MacOS:$PATH"

export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -t __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

