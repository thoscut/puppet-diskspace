#Diskspace facts

## Overview

Creates facts for diskspace use and free space.  Special characters will be omitted from fact names.
Filesystems entitled ```/``` will be listed as ```root``` instead.

## Examples

###*nix style systems
```
# facter -p | grep diskspace
diskspace_boot => 35
diskspace_dev => 1
diskspace_root => 42
diskspacefree_boot => 65
diskspacefree_dev => 99
diskspacefree_root => 58
diskspacefreekb_boot => 150679
diskspacefreekb_dev => 32962772
diskspacefreekb_root => 27438040
diskspacetotalkb_boot => 240780
diskspacetotalkb_dev => 32962776
diskspacetotalkb_root => 49181880
```

###Windows systems
```
C:\>facter -p | find "diskspace"
diskspace_c => 17
diskspacefree_c => 83
diskspacefreekb_c => 69533888
```




