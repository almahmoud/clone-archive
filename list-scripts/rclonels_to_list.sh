#!/bin/bash
# usage: bash list-scripts/rclonels_to_list.sh archive.bioconductor.org 8000000000 200 lists/archive
RELEASE=${1:-archive.bioconductor.org}

# Remove dirs
cat list-scripts/$RELEASE.raw | awk  '{print $2" "$1}' > list-scripts/$RELEASE.sizes

sizelimit=${2:-10000000000} # in B
filenumlimit=${3:-50} # 200 files max
outdir=${4:-"lists/$RELEASE"}
sizesofar=0
filenumsofar=0
dircount=1
mkdir -p $outdir
touch "$outdir/tmp_sub_$dircount.txt"
while read -r file size
do
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
  echo "$1/$file" >> "$outdir/tmp_sub_$dircount.txt"
done < list-scripts/$RELEASE.sizes

echo "Done with chunk $dircount with size $sizesofar B and $filenumsofar files"
mv $outdir/tmp_sub_$dircount.txt $outdir/sub_${dircount}_${sizesofar}_${filenumsofar}.txt