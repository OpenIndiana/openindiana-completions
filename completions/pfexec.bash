# OpenIndiana pfexec(1) completion                          -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright (c) 2018, Michal Nowak <mnowak@startmail.com>

_pfexec()
{
  local cur prev i
  _init_completion || return

  for (( i=1; i <= COMP_CWORD; i++ )); do
    if [[ ${COMP_WORDS[i]} != -* ]]; then
      local PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
      local root_command=${COMP_WORDS[i]}
      _command_offset $i
      return
    fi
    [[ ${COMP_WORDS[i]} == "-P" ]] && ((i++))
  done

  # Get profile names from profile description database, see prof_attr(4)
  if [[ "${prev}" == "-P" ]]; then
    COMPREPLY=( $(compgen -W "$(awk -F: '/^[A-Z]/ {print $1}' /etc/security/prof_attr)" -P \' -S \' -- "${cur}") )
  fi
  if [[ "${cur}" == -* ]]; then
    COMPREPLY=( "-P" )
  fi
}

complete -F _pfexec pfexec

# ex: filetype=sh
# vim: tabstop=2 shiftwidth=2 expandtab smartindent
