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
  EX_DIRS="examples/helloWorld examples/simplest examples/simpleTypesDemo examples/org examples/netEnabled"
  #EX_DIRS="examples/org"
}


output_form_begin()
{
  echo "<html> <head> <title>$TITLE</title>"  >> $HTML_NAME
  echo "<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-18904337-3']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
" >> $HTML_NAME
  echo " </head> <h2>$TITLE <hr NOSHADE SIZE=10 WIDTH=100%> </h2> <body> <form>"  >> $HTML_NAME
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

  if [ ! -z "$README_FILES" ]; then
    echo " <li> <b>README files</b>" >> $HTML_NAME
    echo "  <ul>" >> $HTML_NAME
    for FILE in $README_FILES
    do
      ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
       echo "   <li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
    done
    echo "  </ul>" >> $HTML_NAME
    echo "<br><br>" >> $HTML_NAME
  fi  

  echo " <li> <b>XML Schema Files</b>" >> $HTML_NAME
  echo "  <ul>" >> $HTML_NAME
  CNT_XSD=`echo $XSD_FILES | wc -l`
  for FILE in $XSD_FILES
  do
    ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
    if [ $INPUT_XSD = $FILE ]; then
      echo "   <li> <b><a href=\"#$ESC_FILE\">$FILE</a></b><code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; => Input XML Schema</code>" >> $HTML_NAME
    else
      echo "   <li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
    fi
  done
  echo "  </ul>" >> $HTML_NAME
  echo "<br><br>" >> $HTML_NAME
  
  echo " <li> <b>Related XML Files</b>" >> $HTML_NAME
  echo "  <ul>" >> $HTML_NAME
  for FILE in $XML_FILES
  do
    ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
     echo "   <li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
  done
  echo "  </ul>" >> $HTML_NAME
  echo "<br><br>" >> $HTML_NAME


  echo " <li> <b>Files generated using <i>"xsd2cpp"</i></b> (along with directory structure)" >> $HTML_NAME
  echo "  <ul>" >> $HTML_NAME
  echo "<br>" >> $HTML_NAME
  echo " <li> <i>Generated Header(.h) Files</i>" >> $HTML_NAME
  echo "  <ul>" >> $HTML_NAME
  for FILE in $H_FILES
  do
    ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
     echo "   <li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
  done
  echo "  </ul>" >> $HTML_NAME
  
  echo "<br>" >> $HTML_NAME
  echo " <li> <i>Generated Implementation(.cpp) Files</i>" >> $HTML_NAME
  echo "  <ul>" >> $HTML_NAME
  for FILE in $CPP_FILES
  do
    ESC_FILE=`echo $FILE | sed -e 's/\//_/g'`
     echo "   <li> <a href=\"#$ESC_FILE\">$FILE</a>" >> $HTML_NAME
  done
  echo "  </ul>" >> $HTML_NAME
  
  echo "  </ul>" >> $HTML_NAME # end generated files
  echo "<br><br>" >> $HTML_NAME
  
  echo "</ul>" >> $HTML_NAME

}

get_INPUT_XSD()
{
  INPUT_XSD=`ls -1 $DIR/*.xsd`
  cnt_xsds=`echo "$INPUT_XSD" | wc -l | sed -e 's/ *//g'`
  if [ $cnt_xsds -ne 1 ]; then
    if [ -f $DIR/README ]; then
      INPUT_XSD=$DIR/`cat $DIR/README | grep INPUT_XSD | cut -d= -f2 | sed -e 's/ *//g'`
      if [ -z "$INPUT_XSD" ]; then
        echo "unable to ascertain INPUT_XSD, exiting..."
        fail_test
      fi
    else  
      echo "unable to ascertain INPUT_XSD in dir:$dir, exiting..."
      fail_test
    fi
  fi
}

output_dir()
{
  ESC_DIR=`echo $DIR | sed -e 's/\//_/g'`
  get_INPUT_XSD
  README_FILES=`ls -1 $DIR/README* | grep -v build.txt 2>/dev/null`
  XSD_FILES=`ls -1 $DIR/*.xsd $DIR/*.xs 2>/dev/null`
  XML_FILES=`ls -1 $DIR/*.xml 2>/dev/null`
  CPP_FILES=`find $DIR -name "*.cpp" `
  H_FILES=`find $DIR -name "*.h"`
  ALL_FILES="$README_FILES $XSD_FILES $XML_FILES $MAIN_CPP $H_FILES $CPP_FILES"  
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
  echo "$DESCR" >> $HTML_NAME
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
  HTML_NAME=examples_complete.html
  TITLE="Examples with Generated Source"
  VERSION=`xsd2cpp -v | grep XmlPlus`
  DESCR="The examples and generated files as of <u><i>$VERSION</i></u> .<br> Many examples have been ommited to avoid verbosity. <br>(code generator:</b> <i>xsd2cpp</i>)"
  > $HTML_NAME
  output_dir_html
}

#main
output_all_dirs_html
