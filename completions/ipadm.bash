# OmniOS ipadm(8) completion                                -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

_ipadm()
{
    local cur prev words cword
    _init_completion || return

    local subcmds="add-ipmp create-addr create-if create-ip create-ipmp
                   delete-addr delete-if delete-ip delete-ipmp disable-addr
                   disable-if down-addr enable-addr enable-if refresh-addr
                   remove-ipmp reset-addrprop reset-ifprop reset-prop
                   set-addrprop set-ifprop set-prop show-addr show-addrprop
                   show-if show-ifprop show-prop up-addr"

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
      -m)
        COMPREPLY=( $(compgen -W \
            "$(ipadm show-prop -c -o proto 2>/dev/null | sort -u)" -- ${cur}) )
        return
        ;;
      -T)
        COMPREPLY=( $(compgen -W "static dhcp addrconf" -- ${cur}) )
        return
        ;;
      -p)
        local props
        case "${command}" in
          *-ifprop)
            props="$(ipadm show-ifprop -c -o property 2>/dev/null | sort -u)"
            ;;
          *-addrprop)
            props="$(ipadm show-addrprop -c -o property 2>/dev/null | sort -u)"
            ;;
          *-prop)
            props="$(ipadm show-prop -c -o property 2>/dev/null | sort -u)"
            ;;
        esac
        COMPREPLY=( $(compgen -W "${props}" -- ${cur}) )
        return
        ;;
    esac

    case "${command}" in
      create-if|create-ip)
        # The operand is an existing datalink
        COMPREPLY=( $(compgen -W \
            "$(dladm show-link -p -o link 2>/dev/null)" -- ${cur}) )
        ;;
      create-addr|create-ipmp)
        # The operand is a new object name
        ;;
      *-ifprop|*-if|*-ip|*-ipmp)
        COMPREPLY=( $(compgen -W \
            "$(ipadm show-if -p -o ifname 2>/dev/null)" -- ${cur}) )
        ;;
      *-addrprop|*-addr)
        COMPREPLY=( $(compgen -W \
            "$(ipadm show-addr -p -o addrobj 2>/dev/null)" -- ${cur}) )
        ;;
      set-prop|reset-prop|show-prop)
        COMPREPLY=( $(compgen -W \
            "$(ipadm show-prop -c -o proto 2>/dev/null | sort -u)" -- ${cur}) )
        ;;
    esac
}

complete -F _ipadm ipadm

# ex: filetype=sh
# vim: tabstop=4 shiftwidth=4 expandtab smartindent
