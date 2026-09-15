# OpenIndiana zlogin(1) completion                          -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright (c) 2013, Jonathan Perkin <jperkin@joyent.com>
# Copyright (c) 2018, Michal Nowak <mnowak@startmail.com>

_zlogin()
{
    local cur prev line
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    line="${COMP_LINE}"

    # zlogin [-dCEQ] [-e c] [-l username] zonename
    # zlogin [-nEQS] [-e c] [-l username] zonename utility [argument]...
    local opts="-E -Q -e -l"
    local opts_interactive="-d -C"
    local opts_util="-n -S"

    if [[ "${cur}" == -* ]]
    then
      case "${line}" in
        *\ -n\ *|*\ -S\ *)
          COMPREPLY=( $(compgen -W "${opts} ${opts_util}" -- "${cur}") )
          ;;
        *\ -d\ *|*\ -C\ *)
          COMPREPLY=( $(compgen -W "${opts} ${opts_interactive}" -- "${cur}") )
          ;;
        *)
          COMPREPLY=( $(compgen -W "${opts} ${opts_util} ${opts_interactive}" -- "${cur}") )
          ;;
        esac
    else
      # Provide running zone names
      local zones=$(zoneadm list -n)
      COMPREPLY=( $(compgen -W "${zones}" -- ${cur}) )
    fi
}

complete -F _zlogin zlogin

# ex: filetype=sh
# vim: tabstop=2 shiftwidth=2 expandtab smartindent
