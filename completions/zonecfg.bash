# OmniOS zonecfg(8) completion                              -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_zonecfg()
{
    local cur prev words cword
    _init_completion || return

    case "${prev}" in
      -z)
        COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        return
        ;;
      -t)
        # zonecfg -z <zone> create -t <template-zone>
        COMPREPLY=( $(compgen -W "$(zoneadm list -cn)" -- ${cur}) )
        return
        ;;
    esac

    if [[ "${cur}" == -* ]]; then
      COMPREPLY=( $(compgen -W "-z" -- ${cur}) )
      return
    fi

    # Sub-commands that are useful directly from the command line; the
    # full set is generally used from within an interactive session.
    local i
    for (( i=1; i < ${cword}; i++ )); do
      [[ "${words[i]}" == "-z" ]] && (( i++ )) && break
    done
    if (( cword == i + 1 )); then
      COMPREPLY=( $(compgen -W "create delete export info verify" -- ${cur}) )
    fi
}

complete -F _zonecfg zonecfg

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
