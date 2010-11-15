#!/bin/sh

#
#  XmlPlus : adapted from detect.bat
#

if [ $# -ne 1 ]; then
  echo "Usage: `basename $0` <XML-Schema-File>"
  exit 2
fi

java -jar ./lib/saxon8.jar -novw -o ./results.html $1 ./annotated_results.xsl

echo
echo "Check the output annotations in ./results.html"
echo
