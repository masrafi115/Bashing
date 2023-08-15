#!/bin/bash

while read PACKAGE; do
  SUMMARY=$(apt-cache show $PACKAGE | grep -i "^description:")
  echo "pkg: "$PACKAGE" ""$SUMMARY" >> summery_packages.termux.org.txt
done < packages.txt
