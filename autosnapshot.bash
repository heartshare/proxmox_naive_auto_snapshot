#!/bin/bash
getSnapshots(){
        qm listsnapshot $1 | grep -o -e 'auto_[0-9]*' | sort | uniq
}

takeSnapshot(){
        name="auto_$(date +%s)"
        qm snapshot $1 $name --description "auto" --vmstate true
}

removeOldSnapshots(){
        DAYS_AGO=$(date +%s --date="10 days ago")
        getSnapshots $vm  | cut -c 6- | xargs -L1 -I {} sh -c "\
                [ $DAYS_AGO -gt {} ] && qm delsnapshot  $vm auto_{}"
}

VMS=( 102 103 )
for vm in "${VMS[@]}"
do
        takeSnapshot $vm
        removeOldSnapshots $vm
done
