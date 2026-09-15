# OmniOS zadm(8) completion                                 -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_zadm()
{
    local cur prev words cword
    _init_completion || return

    local cmds="brands console create delete doc edit fw help install list
                list-images log login man memstat poweroff pull reset restart
                rollback set show snapshot start stop uninstall vacuum
                version"

    case "${prev}" in
      -b)
        # Same source as zadm itself uses for the installed brand list
        COMPREPLY=( $(compgen -W \
            "$(nawk -F\" '/<brand name=/ {print $2}' \
            /usr/lib/brand/*/config.xml 2>/dev/null)" -- ${cur}) )
        return
        ;;
      -s)
        COMPREPLY=( $(compgen -W \
            "configured incomplete installed ready running shutting_down
             down" -- ${cur}) )
        return
        ;;
    esac

    local i command
    for (( i=1; i < ${cword}; i++ )); do
      if [[ " ${cmds} " == *" ${words[i]} "* ]]; then
        command="${words[i]}"
        break
      fi
    done

    if [[ -z "${command}" ]]; then
      COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
      return
    fi

    case "${command}" in
      console|delete|edit|fw|install|log|login|poweroff|reset|restart|\
      rollback|set|show|snapshot|start|stop|uninstall)
        COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        ;;
      list)
        if [[ "${cur}" == -* ]]; then
          COMPREPLY=( $(compgen -W "-H -F -b -s" -- ${cur}) )
        else
          COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        fi
        ;;
      list-images|doc)
        [[ "${cur}" == -* ]] && \
            COMPREPLY=( $(compgen -W "-b" -- ${cur}) )
        ;;
    esac
}

complete -F _zadm zadm

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
