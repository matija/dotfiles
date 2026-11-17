autoload -Uz vcs_info
precmd() {
  local last_status=$?
  vcs_info
  PROMPT=$'\n''%F{magenta}%n%f at %F{yellow}%m%f in %F{green}%~%f'
  [[ -n ${vcs_info_msg_0_} ]] && PROMPT+=" on %F{blue}git%f:${vcs_info_msg_0_}"
  if (( last_status && last_status != 130 )); then
    PROMPT+=$'\n%F{red}$%f '
  else
    PROMPT+=$'\n$ '
  fi
}
zstyle ':vcs_info:git:*' formats '%b%c%u'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
unsetopt PROMPT_SUBST
