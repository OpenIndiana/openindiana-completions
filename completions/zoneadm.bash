# OmniOS zoneadm(8) completion                              -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_zoneadm()
{
    local cur prev words cword
    _init_completion || return

    local subcmds="attach boot clone detach halt help install list mark
                   move ready reboot shutdown uninstall verify"

    case "${prev}" in
      -z)
        COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        return
        ;;
      -u)
        return
        ;;
    esac

    local i command
    for (( i=1; i < ${cword}; i++ )); do
      if [[ " ${subcmds} " == *" ${words[i]} "* ]]; then
        command="${words[i]}"
        break
      fi
    done

    if [[ -z "${command}" ]]; then
      if [[ "${cur}" == -* ]]; then
        COMPREPLY=( $(compgen -W "-z -u" -- ${cur}) )
      else
        COMPREPLY=( $(compgen -W "${subcmds}" -- ${cur}) )
      fi
      return
    fi

    case "${command}" in
      clone)
        # zoneadm -z <new-zone> clone <source-zone>
        COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        ;;
      mark)
        COMPREPLY=( $(compgen -W "incomplete" -- ${cur}) )
        ;;
      list)
        [[ "${cur}" == -* ]] && \
            COMPREPLY=( $(compgen -W "-c -i -n -p -v" -- ${cur}) )
        ;;
    esac
}

complete -F _zoneadm zoneadm

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
