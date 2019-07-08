#!/bin/bash
showHelp(){
  echo "Usage: autosnapshot OPTION VM_ID..."
  echo "Automatic snapshotting for Proxmox PVE"
  echo
  echo "  -p, --purge-date      Removes automatic snapshots when whey are older than this."
  echo "                        Uses `date --date` formatting. Eg. '10 days ago'" 
  exit 0 
}

if [[ $# -eq 0 ]] ; then
  showHelp
fi

# argument parsing sample: https://stackoverflow.com/a/14203146/1481004
VMS=()

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--purge-date)
    PURGE_DATE="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    showHelp
    ;;
    *)    # unknown option
    VMS+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

getSnapshots(){
        qm listsnapshot $1 | grep -o -e 'auto_[0-9]*' | sort | uniq
}

takeSnapshot(){
        name="auto_$(date +%s)"
        qm snapshot $1 $name --description "auto" --vmstate true
}

removeOldSnapshots(){
        DAYS_AGO=$(date +%s --date="${PURGE_DATE}")
        getSnapshots $vm  | cut -c 6- | xargs -L1 -I {} sh -c "\
                [ $DAYS_AGO -gt {} ] && qm delsnapshot  $vm auto_{}"
}

for vm in "${VMS[@]}"
do
        takeSnapshot $vm
        removeOldSnapshots $vm
done
