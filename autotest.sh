#!/bin/bash
while true; do
find `pwd` | grep -E ".(c|h)$" | grep -v "/.git/" | entr -d sh -c "tput reset; make test;echo;date"
done
