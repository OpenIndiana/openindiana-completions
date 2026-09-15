# OmniOS flowadm(8) completion                              -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_flowadm()
{
    local cur prev words cword
    _init_completion || return

    local subcmds="add-flow remove-flow show-flow
                   set-flowprop reset-flowprop show-flowprop"

    local i command
    for (( i=1; i < ${cword}; i++ )); do
      if [[ " ${subcmds} " == *" ${words[i]} "* ]]; then
        command="${words[i]}"
        break
      fi
    done

    if [[ -z "${command}" ]]; then
      COMPREPLY=( $(compgen -W "${subcmds}" -- ${cur}) )
      return
    fi

    case "${prev}" in
      -l)
        COMPREPLY=( $(compgen -W \
            "$(dladm show-link -p -o link 2>/dev/null)" -- ${cur}) )
        return
        ;;
      -p)
        COMPREPLY=( $(compgen -W "maxbw priority" -- ${cur}) )
        return
        ;;
      -a)
        COMPREPLY=( $(compgen -W \
            "local_ip remote_ip transport local_port remote_port dsfield" \
            -- ${cur}) )
        return
        ;;
    esac

    if [[ "${command}" != "add-flow" ]]; then
      COMPREPLY=( $(compgen -W \
          "$(flowadm show-flow 2>/dev/null | nawk 'NR>1 {print $1}')" \
          -- ${cur}) )
    fi
}

complete -F _flowadm flowadm

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
