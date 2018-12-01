# OpenIndiana zpool(1M) completion                          -*- shell-script -*-
# ------------------------------------------------------------------------------
# Copyright (c) 2017, Aurelien Larcher <aurelien@openindiana.org>
# Copyright (c) 2018, Michal Nowak <mnowak@startmail.com>

# Bash-completion does not handle custom wordbreaks so comma-separated values
# cannot be implemented without this.
COMP_WORDBREAKS="${COMP_WORDBREAKS//,},"

_zpool()
{
  local cur prev words cword
  _init_completion -n : || return

  local cmds="create destroy add remove labelclear checkpoint list iostat status online offline clear reopen attach detach replace split initialize scrub import export upgrade reguid history get set"
  local cmd_opts=""
  local zpool_properties="allocated bootsize capacity expandsize fragmentation free freeing health guid size unsupported@ altroot readonly=on readonly=off autoexpand=on autoexpand=off autoreplace=on autoreplace=off bootfs= cachefile= comment= dedupditto= delegation= failmode=wait failmode=continue failmode=panic feature@ listsnapshots=on listsnapshots=off version="

  # Lookup for command
  local special i
  for (( i=1; i < $cword; i++ ))
  do
    if [[ ${words[i]} == @(create|destroy|add|remove|labelclear|checkpoint|list|iostat|status|online|offline|clear|reopen|attach|detach|replace|split|initialize|scrub|import|export|upgrade|reguid|history|get|set) ]]
    then
      special=${words[i]}
      break
    fi
  done

  if [[ -z "${special}" ]]
  then
    if [[ "${cur}" == -* ]]
    then
      COMPREPLY=( $(compgen -W "-?" -- "${cur}") )
      return
    else
      COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
      return
    fi
  else
    # Command options
    if [[ "${cur}" == -* ]]
    then
      case "${special}" in
        create)
          # create [-fnd] [-B] [-o property=value] ...
          #   [-O file-system-property=value] ...
          #   [-m mountpoint] [-R root] <pool> <vdev> ...
          cmd_opts="-f -n -d -B -o -O -m -R"
          ;;
        destroy)
          # destroy [-f] <pool>
          cmd_opts="-f"
          ;;
        add)
          # add [-fn] <pool> <vdev> ...
          cmd_opts="-f -n"
          ;;
        remove)
          # remove [-np] pool device...
          # remove -s pool
          cmd_opts="-n -p -s"
          ;;
        labelclear)
          # labelclear [-f] device
          cmd_opts="-f"
          ;;
        checkpoint)
          # checkpoint [-d, --discard]
          cmd_opts="-d --discard"
          ;;
        list)
          # list [-Hp] [-o property[,...]] [-T d|u] [pool] ... [interval [count]]
          cmd_opts="-H -p -o -T"
          ;;
        iostat)
          # iostat [-v] [-T d|u] [pool] ... [interval [count]]
          cmd_opts="-v -T"
          ;;
        status)
          # status [-vx] [-T d|u] [pool] ... [interval [count]]
          cmd_opts="-v -x -T"
          ;;
        online)
          # online <pool> <device> ...
          cmd_opts=""
          ;;
        offline)
          # offline [-t] <pool> <device> ...
          cmd_opts="-t"
          ;;
        clear)
          # clear [-nF] <pool> [device]
          cmd_opts="-n -F"
          ;;
        reopen)
          # reopen <pool>
          cmd_opts=""
          ;;
        attach)
          # attach [-f] <pool> <device> <new-device>
          cmd_opts="-f"
          ;;
        detach)
          # detach <pool> <device>
          cmd_opts=""
          ;;
        replace)
          # replace [-f] <pool> <device> [new-device]
          cmd_opts="-f"
          ;;
        split)
          # split [-n] [-R altroot] [-o mntopts]
          #    [-o property=value] <pool> <newpool> [<device> ...]
          cmd_opts="-n -R -o"
          ;;
        initialize)
          # initialize [-cs] pool [device...]
          cmd_opts="-c -s"
          ;;
        scrub)
          # scrub [-s | -p] <pool> ...
          cmd_opts="-s -p"
          ;;
        import)
          # import [-d dir] [-D]
          # import [-d dir | -c cachefile] [-F [-n]] <pool | id>
          # import [-o mntopts] [-o property=value] ...
          #   [-d dir | -c cachefile] [-D] [-f] [-m] [-N] [-R root] [-F [-n]] -a
          # import [-o mntopts] [-o property=value] ...
          #   [-d dir | -c cachefile] [-D] [-f] [-m] [-N] [-R root] [-F [-n]]
          #   <pool | id> [newpool]
          cmd_opts="-d -D -c -F -n -o -f -m -N -R -a"
          ;;
        export)
          # export [-f] <pool> ...
          cmd_opts="-f"
          ;;
        upgrade)
          # upgrade
          # upgrade -v
          # upgrade [-V version] <-a | pool ...>
          cmd_opts="-v -V -a"
          ;;
        reguid)
          # reguid <pool>
          cmd_opts=""
          ;;
        history)
          # history [-il] [<pool>] ...
          cmd_opts="-i -l"
          ;;
        get)
          # get [-Hp] [-o "all" | field[,...]] <"all" | property[,...]> <pool> ...
          cmd_opts="-H -p -o"
          ;;
        set)
          # set <property=value> <pool>
          cmd_opts=""
          ;;
      esac
      COMPREPLY=( $(compgen -W "${cmd_opts}" -- "${cur}") )
      return
    else
      case "${special}" in
        create)
          # create [-fnd] [-B] [-o property=value] ...
          #   O file-system-property=value] ...
          #   m mountpoint] [-R root] <pool> <vdev> ...
          case "${prev}" in
            -o)
              # Zpool property
              compopt -o nospace
              COMPREPLY=( $(compgen -W "$(zpool get 2>&1 | nawk '$2 == "YES" {print $1}')" -S '=' -- "${cur}") )
              return
              ;;
          esac
          ;;
        destroy)
          # destroy [-f] <pool>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        add)
          # add [-fn] <pool> <vdev> ...
          case "${prev}" in
            add|-f|-n)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -Hv ${prev} | nawk 'NR>1 && $1 !~ "raid|mirror" { print $1 }')" -- "${cur}") )
              return
              ;;
          esac
          ;;
        remove)
          # remove [-np] pool device...
          # remove -s pool
          case "${prev}" in
            remove|-n|-p|-s)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -Hv ${prev} | nawk 'NR>1 && $1 !~ "raid|mirror" { print $1 }')" -- "${cur}") )
              return
              ;;
          esac
          ;;
        labelclear)
          # labelclear [-f] device
          # TODO: List devices?
          ;;
        checkpoint)
          # checkpoint [-d, --discard] pool
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          ;;
        list|iostat|status)
          # list [-Hp] [-o property[,...]] [-T d|u] [pool] ... [interval [count]]
          # iostat [-v] [-T d|u] [pool] ... [interval [count]]
          # status [-vx] [-T d|u] [pool] ... [interval [count]]
          case "${prev}" in
            -o)
              if [[ "${special}" != "list" ]]; then return; fi;
              # Zpool property
              compopt -o nospace
              COMPREPLY=( $(compgen -W "$(zpool get 2>&1 | nawk '$2 == "NO" || $2 == "YES" {print $1}')" -- "${cur}") )
              return
              ;;
            -T)
              COMPREPLY=( $(compgen -W "d u" -- "${cur}") )
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
          esac
          ;;
        online)
          # online <pool> <device> ...
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        offline)
          # offline [-t] <pool> <device> ...
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        clear)
          # clear [-nF] <pool> [device]
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        reopen)
          # reopen <pool>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        attach)
          # attach [-f] <pool> <device> <new-device>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          ;;
        detach)
          # detach <pool> <device>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        replace)
          # replace [-f] <pool> <device> [new-device]
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        split)
          # split [-n] [-R altroot] [-o mntopts]
          #   [-o property=value] <pool> <newpool> [<device> ...]
          case "${prev}" in
            -o)
              COMPREPLY=( $(compgen -W "$zpool_properties" -- "${cur}") )
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
          esac
          ;;
        initialize)
          # initialize [-cs] pool [device...]
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        scrub)
          # scrub [-s | -p] <pool> ...
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        import)
          # import [-d dir] [-D]
          # import [-d dir | -c cachefile] [-F [-n]] <pool | id>
          # import [-o mntopts] [-o property=value] ...
          #   [-d dir | -c cachefile] [-D] [-f] [-m] [-N] [-R root] [-F [-n]] -a
          # import [-o mntopts] [-o property=value] ...
          #   [-d dir | -c cachefile] [-D] [-f] [-m] [-N] [-R root] [-F [-n]]
          #   <pool | id> [newpool]
          case "${prev}" in
            -d|-c)
              _cd
              return
              ;;
            -o)
              COMPREPLY=( $(compgen -W "$zpool_properties" -- "${cur}") )
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
          esac
          ;;
        export)
          # export [-f] <pool> ...
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        upgrade)
          # upgrade
          # upgrade -v
          # upgrade [-V version] <-a | pool ...>
          case "${prev}" in
            -V)
              COMPREPLY=( $(compgen -W "$(zpool upgrade -v | nawk '/^ [0-9]/ {print $1}')" -- "${cur}") )
              return
              ;;
            -a|-v)
              return
              ;;
            *)
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
            esac
            ;;
        reguid)
          # reguid <pool>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        history)
          # history [-il] [<pool>] ...
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
        get)
          # get [-Hp] [-o "all" | field[,...]] <"all" | property[,...]> <pool> ...
          case "${prev}" in
            -o)
              # Zpool property field
              compopt -o nospace
              COMPREPLY=( $(compgen -W "name property value source all"  -- "${cur}") )
              return
              ;;
            ,)
              # Check whether the field or property list is being completed
              local pprev="${COMP_WORDS[COMP_CWORD-2]}"
              if [[ ${pprev} == @(name|property|value|source|all) ]]
              then
                  # Zpool property field
                  local realcur=${cur##*,}
                  compopt -o nospace
                  COMPREPLY=( $(compgen -W "name property value source all"  -- "${realcur}") )
                  return
              else
                  # Zpool property
                  local realcur=${cur##*,}
                  compopt -o nospace
                  COMPREPLY=( $(compgen -W "$(zpool get 2>&1 | nawk '$2 == "NO" || $2 == "YES" {print $1}')" -- "${realcur}") )
                  return
              fi
              ;;
            get|-*|name|property|value|source|all)
              if [[ ${cur} == ,* ]]
              then
                  # Zpool property field
                  local realcur=${cur##*,}
                  compopt -o nospace
                  COMPREPLY=( $(compgen -W "name property value source all"  -- "${realcur}") )
                  return
              fi
              # Zpool property
              compopt -o nospace
              COMPREPLY=( $(compgen -W "$(zpool get 2>&1 | nawk '$2 == "NO" || $2 == "YES" {print $1}')" -- "${cur}") )
              return
              ;;
            *)
              if [[ ${cur} == ,* ]]
              then
                  # Zpool property
                  local realcur=${cur##*,}
                  compopt -o nospace
                  COMPREPLY=( $(compgen -W "$(zpool get 2>&1 | nawk '$2 == "NO" || $2 == "YES" {print $1}')" -- "${realcur}") )
                  return
              fi
              COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
              return
              ;;
          esac
          return
          ;;
        set)
          # set <property=value> <pool>
          COMPREPLY=( $(compgen -W "$(zpool list -H -o name)" -- "${cur}") )
          return
          ;;
      esac
    fi
  fi
} &&
  complete -F _zpool +o default zpool

# ex: filetype=sh
# vim: tabstop=2 shiftwidth=2 expandtab smartindent
