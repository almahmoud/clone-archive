#!/bin/bash
# usage: bash list-scripts/rclonels_to_list.sh archive2 8000000000 200 lists/archive archive.bioconductor.org
RAWDIR=${1:-archive}

# Remove dirs
cat list-scripts/$RAWDIR.ls | awk  '{print $2" "$1}' > list-scripts/$RAWDIR.sizes

sizelimit=${2:-10000000000} # in B
filenumlimit=${3:-50} # 200 files max
outdir=${4:-"lists/$RAWDIR"}
outdirlast=$(echo $outdir | awk -F'/' '{print $NF}')
dupsoutdir=$(echo $outdir | sed "s/$outdirlast/dups_$outdirlast/g")
LISTPREFIX=${5:-$RAWDIR}
sizesofar=0
filenumsofar=0
dircount=1
lastsize=0
lastfilename=""
filename=""
mkdir -p $outdir
mkdir -p $dupsoutdir
touch "$outdir/tmp_sub_$dircount.txt"
while read -r filepath size
do
  filename=$(echo $filepath | awk -F'/' '{print $NF}')
  if ((sizesofar + size > sizelimit || filenumsofar >= filenumlimit ))
  then
    echo "Done with chunk $dircount with size $sizesofar B and $filenumsofar files"
    mv $outdir/tmp_sub_$dircount.txt $outdir/sub_${dircount}_${sizesofar}_${filenumsofar}.txt
    (( dircount++ ))
    sizesofar=0
    filenumsofar=0
    touch "$outdir/tmp_sub_$dircount.txt"
  fi
  (( sizesofar += size ))
  (( filenumsofar += 1 ))
  if [ "$filename" == "$lastfilename" ] && (( size == lastsize ))
  then
    echo "$lastsize $LISTPREFIX/$lastfilepath" >> "$dupsoutdir/dups.txt"
    echo "$size $LISTPREFIX/$filepath" >> "$dupsoutdir/dups.txt"
  else
    echo "$LISTPREFIX/$filepath" >> "$outdir/tmp_sub_$dircount.txt"
  fi
  lastfilename=$(echo $filename)
  lastsize=$size
  lastfilepath=$(echo $filepath)
done < list-scripts/$RAWDIR.sizes

echo "Done with chunk $dircount with size $sizesofar B and $filenumsofar files"
mv $outdir/tmp_sub_$dircount.txt $outdir/sub_${dircount}_${sizesofar}_${filenumsofar}.txt