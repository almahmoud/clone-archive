#!/bin/bash
# usage: bash list-scripts/server_side_dups_copy.sh "osn:bir190004-bucket01" archive2 lists/archive archive.bioconductor.org

DESTINATION=${1:-"js2:"A}

RAWDIR=${2:-archive}

outdir=${3:-"lists/$RAWDIR"}
outdirlast=$(echo $outdir | awk -F'/' '{print $NF}')
dupsoutdir=$(echo $outdir | sed "s/$outdirlast/dups_$outdirlast/g")
LISTPREFIX=${4:-""}
sizesofar=0
filenumsofar=0
dircount=1
lastsize=0
lastfilename=""
filename=""
mkdir -p $outdir
mkdir -p $dupsoutdir
touch "$outdir/tmp_sub_$dircount.txt"
while read -r size filepath
do
  filename=$(echo $filepath | awk -F'/' '{print $NF}')
  if [ "$filename" == "$lastfilename" ] && (( size == lastsize ))
  then
    echo "rclone copyto $DESTINATION/$LISTPREFIX/$lastfilepath $DESTINATION/$LISTPREFIX/$filepath -vvvvvv" >> "$dupsoutdir/sscopy.txt"
  fi
  lastfilename=$(echo $filename)
  lastsize=$size
  lastfilepath=$(echo $filepath)
done < $dupsoutdir/uniq.txt

