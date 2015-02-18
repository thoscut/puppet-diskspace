#Diskspace facts

## Overview

Creates facts for diskspace use and free space.  Special characters will be omitted from fact names.
Filesystems entitled ```/``` will be listed as ```root``` instead.

## Examples

###*nix style systems
```
# facter -p | grep diskspace
diskspace_boot => 31
diskspace_devshm => 0
diskspace_root => 54
diskspacefree_boot => 69
diskspacefree_devshm => 100
diskspacefree_root => 46
```

###Windows systems
```
C:\>facter -p | find "diskspace"
diskspace_c => 31
diskspacefree_c => 69
```
