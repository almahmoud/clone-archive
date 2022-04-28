#!/bin/bash

git pull origin main || git reset --hard origin/main
mkdir -p lists/done/$(dirname $1) && mv lists/running/$1 lists/done/$1
git add lists
git commit -m "Done $1"
