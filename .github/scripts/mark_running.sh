#!/bin/bash

git pull origin main || git reset --hard origin/main && git pull origin main
mkdir -p lists/running/$(dirname $1) && mv lists/claimed/$1 lists/running/$1
git add lists
git commit -m "Running $1"
