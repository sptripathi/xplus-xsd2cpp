#!/bin/bash

MAIN_CPP=
FILE=""
XSD_FILES=""
XML_FILES=""
EX_DIRS=""
W3C_TESTS_DIRS=""
XPLUS_TESTS_DIRS=""
XPLUS_NEGTESTS_DIRS=""
HTML_NAME=""
DIRS=""
TITLE=""

ascertain_input_dirs()
{
  EX_DIRS=`find examples  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  W3C_TESTS_DIRS=`find Tests/w3c_tests  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  XPLUS_TESTS_DIRS=`find Tests/xplus_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  XPLUS_NEGTESTS_DIRS=`find Tests/xplus_neg_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
}


output_form_begin()
{
  echo "<html> <head> <title>$TITLE</title> </head> <h2>$TITLE <hr NOSHADE SIZE=10 WIDTH=100%> </h2> <body> <form>"  >> $HTML_NAME
}

output_form_end()
{
  echo "</form></body></html>"  >> $HTML_NAME
}


output_file()
{
  ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
  echo "<h3><a name=\"$ESC_FILE\">$FILE</a></h3>"  >> $HTML_NAME 
  #echo "$FILE"  >> $HTML_NAME 
  echo "<div style=\"border:1px dotted black; padding:0em; background-color:#E6E6FA;\">" >> $HTML_NAME
  echo "<pre>" >> $HTML_NAME
  cat $FILE | sed -e 's/</\&lt;/g' | sed -e 's/>/\&gt;/g' >> $HTML_NAME
  #X=`cat $FILE | sed -e 's/</\&lt;/g' | sed -e 's/>/\&gt;/g'`
  #echo "$X"  >> $HTML_NAME 
  echo "</pre>" >> $HTML_NAME
  echo "</div>" >> $HTML_NAME
  echo "<br><br>" >> $HTML_NAME
}

link_files()
{
  echo "<ul>" >> $HTML_NAME
  for FILE in $ALL_FILES
  do
    ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
     echo "<li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
  done
  echo "</ul>" >> $HTML_NAME
}

output_dir()
{
  ESC_DIR=`echo $DIR | sed -e 's/\//_/g'`
  MAIN_CPP=`ls -1 $DIR/main.cpp 2>/dev/null`
  XSD_FILES=`ls -1 $DIR/*.xsd org/*.xs 2>/dev/null`
  XML_FILES=`ls -1 $DIR/*.xml org/*.xs 2>/dev/null`
  ALL_FILES="$XSD_FILES $XML_FILES $MAIN_CPP"  
  echo "<h2><a name=\"$ESC_DIR\">$DIR</a></h2>"  >> $HTML_NAME 
  echo "<hr NOSHADE SIZE=2 WIDTH=100%>" >> $HTML_NAME

  link_files

  for FILE in $ALL_FILES
  do
    output_file
  done
  #echo "<hr NOSHADE SIZE=2 WIDTH=100%>"  >> $HTML_NAME
  echo "<br>"  >> $HTML_NAME
}

link_dirs()
{
  echo "<ul>" >> $HTML_NAME
  for DIR in $DIRS
  do
   ESC_DIR=`echo $DIR | sed -e 's/\//_/g'`
   echo "<li> <a href=\"#$ESC_DIR\">$DIR</a>" >> $HTML_NAME
  done
  echo "</ul>" >> $HTML_NAME
}

output_dir_html()
{
  output_form_begin
  link_dirs
  echo "<br><br>" >> $HTML_NAME
  for DIR in $DIRS
  do
   output_dir
  done
  output_form_end
  echo " => wrote $HTML_NAME"
}

output_all_dirs_html()
{
  ascertain_input_dirs
  
  DIRS=$EX_DIRS
  HTML_NAME=browse_examples.html
  TITLE="Examples"
  > $HTML_NAME
  output_dir_html
  
  DIRS="$W3C_TESTS_DIRS $XPLUS_TESTS_DIRS $XPLUS_NEGTESTS_DIRS"
  HTML_NAME=browse_tests.html
  TITLE="Tests"
  > $HTML_NAME
  output_dir_html
}

#main
output_all_dirs_html
