# Portkey

Portkey is a simple addon for Windower 4 that is a wrapper around [Superwarp](https://github.com/AkadenTK/superwarp).

Mainly intended to simplify the simplest superwarp commands, that don't need arguments, useful for controller players and conserving macro space.

For example, `portkey` will send `ew enter`, `ew exit`, `od port`, `so port`, etc. based on the zone you are in when calling `portkey`.

## Usage

This addon has no configuration.

Simply send the command when near an Escha entrance or exit or anywhere superwarp has a `port` command (odyssey, sortie, temenos, apollyon).

In the chat:
```
//portkey
```

In a macro:
```
/con portkey
```

In the windower console:
```
portkey
```

### IPC

Portkey supports providing an IPC modifier which superwork accepts (all or party), such as `//portkey party` or `//portkey all`.
