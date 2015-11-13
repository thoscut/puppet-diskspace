#Diskspace facts

## Overview

Creates facts for diskspace use and free space.  Special characters will be omitted from fact names.
Filesystems entitled ```/``` will be listed as ```root``` instead.

## Examples

###*nix style systems
```
# facter -p | grep diskspace
diskspace_boot => 15
diskspace_devshm => 0
diskspace_home => 20
diskspace_root => 25
diskspace_var => 14
diskspacefree_boot => 85
diskspacefree_devshm => 100
diskspacefree_home => 80
diskspacefree_root => 75
diskspacefree_var => 86
diskspacefreekb_boot => 401675
diskspacefreekb_devshm => 961780
diskspacefreekb_home => 1568664
diskspacefreekb_root => 5206584
diskspacefreekb_var => 3407840
```

###Windows systems
```
C:\>facter -p | find "diskspace"
diskspace_c => 17
diskspacefree_c => 83
diskspacefreekb_c => 69533888
```




