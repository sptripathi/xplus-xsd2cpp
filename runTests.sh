#!/bin/sh


EX_DIRS="
        examples/org
        examples/includeDemo
        examples/helloWorld
        examples/helloWorldWide
        examples/mails
        examples/simpleTypesDemo
        examples/simplest
        examples/po"
      ex_dirs=""


W3C_TESTS_DIRS="
       w3c_tests/stE080
       w3c_tests/stG003
       w3c_tests/stH005
       w3c_tests/stZ015
       w3c_tests/ste099
       w3c_tests/reDH7a
       w3c_tests/nist5
       w3c_tests/digtest"

#EX_DIRS=
#W3C_TESTS_DIRS=


print_usage()
{
  echo "Usage:"
  echo
  echo " $0  -ct"
  echo "    -c  cleanup all the example directories"
  echo "    -t  test all the example directories"
  echo "    -h  print help"
  echo
}

change_dir_abort()
{
  cd $dir 
  if [ $? -ne 0 ]; then
    echo "failed to change-dir: $dir"
    exit 2
  fi
}

get_input_xsd()
{
  input_xsd=`ls -1 *.xsd`
  cnt_xsds=`echo "$input_xsd" | wc -l | sed -e 's/ *//g'`
  if [ $cnt_xsds -ne 1 ]; then
    if [ -f README ]; then
      input_xsd=`cat README | grep INPUT_XSD | cut -d= -f2 | sed -e 's/ *//g'`
      if [ -z "$input_xsd" ]; then
        echo "unable to ascertain input_xsd, exiting..."; exit 2
      fi
    else  
      echo "unable to ascertain input_xsd in dir:$dir, exiting..."; exit 2
    fi
  fi
}

log_clean_dir()
{
  echo "# cleaning up directory: $dir "
}

log_tests_dir()
{
  echo "# running tests in in directory: $dir "
}

fail_test()
{
  echo "   [ FAILED ]"
  exit 2
}

pass_test()
{
  echo "   [ PASSED ]"
}

cleanup_dir()
{
  log_clean_dir
  change_dir_abort
  find . | grep -v svn | grep -v README | grep -v xsd | grep -v xml | grep -v "main.cpp"  | xargs rm -rf 2>/dev/null 
  rm -f *.template *.bak t.xml* sample.xml *.save  
  cd - > /dev/null 2>&1
  echo "   [ CLEANED ]"  
}

cleanup()
{
  echo "#------------------------------------------------------"
  echo "# cleaning up w3c_tests ..."
  echo "#------------------------------------------------------"
  for dir in $W3C_TESTS_DIRS
  do
    cleanup_dir
  done
  echo "#------------------------------------------------------"

  echo; echo

  echo "#------------------------------------------------------"
  echo "# cleaning up examples ..."
  echo "#------------------------------------------------------"
  for dir in $EX_DIRS
  do
    cleanup_dir
  done
  echo "------------------------------------------------------"
}
  



test_sample()
{
  # write sample.xml
  ./build/bin/$run -s  >> tests.log 2>&1
  
  # check sample.xml exists
  if [ ! -f sample.xml ]; then
    echo "   sample.xml doesn't exist"
    fail_test
  fi
}


test_write()
{
  # write t.xml
  ./build/bin/$run -w  >> tests.log 2>&1
  
  # check t.xml exists
  if [ ! -f t.xml ]; then
    echo "   t.xml doesn't exist"
    fail_test
  fi

  # verify diff
  differ=`diff t.xml valid.xml`
  if [ ! -z "$differ" ]; then
    echo "   failed to compare t.xml with valid.xml"
    fail_test
  fi
}

test_roundtrip()
{
  # rountrip
  ./build/bin/$run -r ./t.xml >> tests.log 2>&1
  
  # check t.xml.rt.xml exists
  if [ ! -f t.xml.rt.xml ]; then
    echo "   t.xml.rt.xml doesn't exist"
    fail_test
  fi

  # verify diff
  differ=`diff t.xml.rt.xml t.xml`
  if [ ! -z "$differ" ]; then
    echo "   failed to compare t.xml.rt.xml with t.xml"
    fail_test
  fi
}

test_dir()
{
  echo
  cd $dir 
  log_tests_dir
  
  > tests.log
  get_input_xsd
  echo "   input: $input_xsd"
  run=`basename $input_xsd | cut -d'.' -f1`run

  # check valid.xml exists
  if [ ! -f valid.xml ]; then
    echo "  valid.xml doesn't exist"
    fail_test
  fi
 
  # verify that the dir builds
  xsd2cpp $input_xsd . >> tests.log 2>&1 && ./autogen.sh >> tests.log 2>&1 &&  make install >> tests.log 2>&1
  if [ $? -ne 0 ]; then
    echo "   failed to build"
    fail_test
  fi
  
  test_sample
  test_write
  test_roundtrip

  pass_test
  cd - >/dev/null 2>&1
}


test_all()
{
  echo "#------------------------------------------------------"
  echo "# running tests on w3c_tests ..."
  echo "#------------------------------------------------------"
  for dir in $W3C_TESTS_DIRS
  do
    test_dir
  done
  echo "#------------------------------------------------------"

  echo;echo

  echo "#------------------------------------------------------"
  echo "# running tests on examples ..."
  echo "#------------------------------------------------------"
  for dir in $EX_DIRS
  do
    test_dir
  done
  echo "#------------------------------------------------------"

  echo; echo
  echo "          ============================           "
  echo "                ALL TESTS PASSED                 "
  echo "          ============================           "
}



args=`getopt hct $*`
if [ $? != 0 ]; then
  print_usage
  exit 2
fi
set -- $args
for i
do
  case "$i" in
    -h)
      print_usage
      shift;;
    -c)
      cleanup
      shift;;
    -t)
      cleanup
      echo;echo
      test_all
      shift;;
    --)
      shift; break;;
  esac
done
