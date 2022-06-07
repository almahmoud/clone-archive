#!/bin/bash
# usage: bash list-scripts/generate_todo.sh archive todo.txt
cd lists
listdir=${1:-archive}
todo=${2:-todo.txt}
ls $listdir/* | sort -V >> $todo
cd ..
