# proxmox_naive_auto_snapshot
Automatic snapshotting of VMs in proxmox

```
➜ ./autosnapshot.bash --help                                     
Usage: autosnapshot OPTION VM_ID...
Automatic snapshotting for Proxmox PVE

  -p, --purge-date      Removes automatic snapshots when whey are older than this.
                        date: option '--date' requires an argument
                        Uses date formatting. Eg. '10 days ago'
```


## Why
I needed a simple, easy to understand / audit solution for making daily snapshots of VM's in Proxmox



## Get started
Make crontab entry with `crontab -e`

```
#Make snapshot every day
2 3 * * * /root/cronSnap
``

```
#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
cd /root/

# Take snapshot and remove old automatic snapshots that is older than 7 days
./autosnapshot -p "7 days ago" 102 103

```
