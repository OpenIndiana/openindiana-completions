# OpenIndiana bootadm(1M) completion                        -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright (c) 2013, Pashev Igor <pashev.igor@gmail.com>
# Copyright (c) 2018, Michal Nowak <mnowak@startmail.com>

_bootadm() {
    local cur prev opts line
    COMPREPLY=()

    cur=${COMP_WORDS[COMP_CWORD]}
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    line="${COMP_LINE}"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "update-archive list-archive install-bootloader set-menu list-menu" -- $cur) )
        return
    fi

    case "$prev" in
    -R)
        _cd
        return;;
    -p)
        COMPREPLY=( $(compgen -W "i86pc sun4v sun4u" -- $cur) )
        return;;
    -F)
        COMPREPLY=( $(compgen -W "cpio hsfs ufs ufs-nocompress" -- $cur) )
        return;;
    -P)
        COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
        return;;
    esac

    case "$line" in
    *update-archive*-R*)
        # update-archive [-vnf] [-R altroot [-p platform]] [-F format ]
        COMPREPLY=( $(compgen -W "-v -n -f -p -F" -- $cur) )
        ;;
    *update-archive*)
        # update-archive [-vnf] [-R altroot [-p platform]] [-F format ]
        COMPREPLY=( $(compgen -W "-v -n -f -R -F" -- $cur) )
        ;;
    *list-archive*-p*-R*)
        # list-archive [-vn] [-R altroot [-p platform]]
        ;&        # fallthru
    *list-archive*-R*-p*)
        # list-archive [-vn] [-R altroot [-p platform]]
        COMPREPLY=( $(compgen -W "-v -n" -- $cur) )
        ;;
    *list-archive*-R*)
        # list-archive [-vn] [-R altroot [-p platform]]
        COMPREPLY=( $(compgen -W "-v -n -p" -- $cur) )
        ;;
    *list-archive*)
        # list-archive [-vn] [-R altroot [-p platform]]
        COMPREPLY=( $(compgen -W "-v -n -R" -- $cur) )
        ;;
    *install-bootloader*)
        # install-bootloader [-Mfv] [-R altroot] [-P pool]
        COMPREPLY=( $(compgen -W "-M -f -v -R -P" -- $cur) )
        ;;
    *set-menu*-R*)
        # set-menu [-R altroot] key=value
        COMPREPLY=( $(compgen -W "default= timeout=" -- $cur) )
        compopt -o nospace
        ;;
    *set-menu*)
        # set-menu [-R altroot] key=value
        COMPREPLY=( $(compgen -W "-R default= timeout=" -- $cur) )
        if [[ ${#COMPREPLY[@]} == 1 && ${COMPREPLY[0]} != -R ]]; then
            compopt -o nospace
        fi
        ;;
    *list-menu*-o*)
        # list-menu [-R altroot] [-o key=value]
        COMPREPLY=( $(compgen -W "entry= title=" -- $cur) )
        if [[ ${#COMPREPLY[@]} == 1 && ${COMPREPLY[0]} != -R ]]; then
            compopt -o nospace
        fi
        ;;
    *list-menu*-R*)
        # list-menu [-R altroot] [-o key=value]
        COMPREPLY=( $(compgen -W "-o" -- $cur) )
        ;;
    *list-menu*)
        # list-menu [-R altroot] [-o key=value]
        COMPREPLY=( $(compgen -W "-R -o" -- $cur) )
        ;;
    esac

}

complete -F _bootadm bootadm

# ex: filetype=sh
# vim: tabstop=2 shiftwidth=2 expandtab smartindent
