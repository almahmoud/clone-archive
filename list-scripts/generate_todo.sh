#!/bin/bash
# usage: bash list-scripts/generate_todo.sh
cd lists
lists=${1:-archive}
todo=${2:-todo.txt}
ls $lists/* | sort -V >> $todo
cd ..
