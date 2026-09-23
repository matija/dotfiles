autoload -Uz vcs_info
precmd() { vcs_info; PROMPT="%F{blue}%1~%f ${vcs_info_msg_0_} " }
zstyle ':vcs_info:git:*' formats '%b'
unsetopt PROMPT_SUBST
