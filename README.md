# illumos completions

This is a set of Bash completions specific to illumos distributions such as
OmniOS and OpenIndiana, covering illumos commands which are not found in the
upstream [bash-completion](https://github.com/scop/bash-completion) project.

It is derived from
[openindiana-completions](https://github.com/OpenIndiana/openindiana-completions).

## Layout

The layout used on this branch follows the directory scheme introduced in
bash-completion 2.18:

- `completions/` holds one `<command>.bash` file per command, loaded
  on-demand the first time completion is attempted for that command. A file
  may provide completions for several related commands, in which case the
  additional command names are symbolic links to it (see `svcadm.bash`,
  which also provides `svcs`, `svcprop` and `svccfg`).
- `startup/` holds files which register completions for many differently
  named commands, such as the `-z <zone>` handling in `zones.bash`. These
  cannot be loaded on-demand and are instead sourced eagerly when
  bash-completion is initialised.
