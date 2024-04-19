# OmniOS fmadm(8) completion                                -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_fmadm()
{
    local cur prev words cword
    _init_completion || return

    local subcmds="acquit config faulty flush load repaired replaced
                   reset rotate unload"

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

    case "${command}" in
      faulty)
        [[ "${cur}" == -* ]] && \
            COMPREPLY=( $(compgen -W "-a -f -g -i -n -p -r -s -u -v" \
                -- ${cur}) )
        ;;
      rotate)
        COMPREPLY=( $(compgen -W "errlog fltlog infolog infolog_hival" \
            -- ${cur}) )
        ;;
      reset|unload)
        COMPREPLY=( $(compgen -W \
            "$(fmadm config 2>/dev/null | nawk 'NR>1 {print $1}')" -- ${cur}) )
        ;;
    esac
}

complete -F _fmadm fmadm

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
