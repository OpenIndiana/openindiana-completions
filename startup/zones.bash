# OpenIndiana zones(7) completion                           -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright (c) 2013, Jonathan Perkin <jperkin@joyent.com>
# Copyright (c) 2018, Michal Nowak <mnowak@startmail.com>
# Copyright 2026 OmniOS Community Edition (OmniOSce) Association.

# This file registers completions for a number of different zone-aware
# utilities and therefore cannot be loaded on-demand by command name; it
# lives in the startup directory, which is sourced eagerly when
# bash-completion is initialised.

_dash_z_zone()
{
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ ${prev} =~ "-z" ]]; then
      local zones="$(zoneadm list -n $*)"
      COMPREPLY=( $(compgen -W "${zones}" -- ${cur}) )
    fi
}

_dash_z_zone_running() { _dash_z_zone; }
_dash_z_zone_configured() { _dash_z_zone -c; }

# Many illumos utilities are zone-aware through the -z option

complete -F _dash_z_zone_running -o default allocate
complete -F _dash_z_zone_running -o default deallocate
complete -F _dash_z_zone_running -o default ipfs
complete -F _dash_z_zone_running -o default ipfstat
complete -F _dash_z_zone_running -o default ipmon
complete -F _dash_z_zone_running -o default ipnat
complete -F _dash_z_zone_running -o default ippool
complete -F _dash_z_zone_running -o default pgrep
complete -F _dash_z_zone_running -o default pkill
complete -F _dash_z_zone_running -o default ps
complete -F _dash_z_zone_running -o default psrset
complete -F _dash_z_zone_running -o default ptree
complete -F _dash_z_zone_running -o default wall

complete -F _dash_z_zone_configured -o default auditreduce

# ex: filetype=sh
# vim: tabstop=2 shiftwidth=2 expandtab smartindent
