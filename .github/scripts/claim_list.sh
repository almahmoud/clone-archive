#!/bin/bash

git pull origin main || git reset --hard origin/main
export first=$(head -n 1 lists/todo.txt)
mkdir -p lists/claimed/$(dirname $first) && mv lists/$first lists/claimed/$first && tail -n 100 -n +2 "lists/todo.txt" > "lists/todo.txt.tmp" && mv "lists/todo.txt.tmp" "lists/todo.txt"
git add lists
git commit -m "Claim $first"
echo $first > "tmp$1"