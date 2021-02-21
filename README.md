# Diskspace facts

[![Build Status](https://travis-ci.org/marcinbojko/puppet-diskspace.svg?branch=master)](https://travis-ci.org/marcinbojko/puppet-diskspace)

## Overview

Creates facts for diskspace use and free space.  Special characters will be omitted from fact names.
Filesystems entitled ```/``` will be listed as ```root``` instead.

## Examples

|Fact prefix|Unit|
|-----------|----|
|diskspace_used_percent_|%|
|diskspace_free_percent_|%|
|diskspace_used_kb_|kb|
|diskspace_free_kb_|kb|
|diskspace_total_kb_|kb|

### *nix style systems

```bash
# puppet facts|grep diskspace
"diskspace_free_kb_boot": 324314,
"diskspace_free_kb_bootefi": 184680,
"diskspace_free_kb_root": 64940456,
"diskspace_free_percent_boot": 67,
"diskspace_free_percent_bootefi": 90,
"diskspace_free_percent_root": 89,
"diskspace_total_kb_boot": 487634,
"diskspace_total_kb_bootefi": 204580,
"diskspace_total_kb_root": 73474080,
"diskspace_used_kb_boot": 163320,
"diskspace_used_kb_bootefi": 19900,
"diskspace_used_kb_root": 8533624,
"diskspace_used_percent_boot": 33,
"diskspace_used_percent_bootefi": 10,
"diskspace_used_percent_root": 11,
```

### Windows systems

```cmd
# puppet facts|findstr -i diskspace
"diskspace_free_kb_c": 23625804,
"diskspace_free_percent_c": 34,
"diskspace_total_kb_c": 71086076,
"diskspace_used_kb_c": 47460272,
"diskspace_used_percent_c": 66,
```

## Authors

Forked from: [https://github.com/WhatsARanjit/puppet-diskspace](https://github.com/WhatsARanjit/puppet-diskspace)
