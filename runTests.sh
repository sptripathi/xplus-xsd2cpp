#!/bin/sh

CNT_TOTAL_TESTS=0
CNT_FAILED_TESTS=0
CNT_PASSED_TESTS=0

TEST_FAILED=false

EX_DIRS="
        examples/org
        examples/includeDemo
        examples/helloWorld
        examples/helloWorldWide
        examples/mails
        examples/simpleTypesDemo
        examples/simplest
        examples/po"

W3C_TESTS_DIRS="
       Tests/w3c_tests/stE080
       Tests/w3c_tests/stG003
       Tests/w3c_tests/stH005
       Tests/w3c_tests/stZ015
       Tests/w3c_tests/ste099
       Tests/w3c_tests/reDH7a
       Tests/w3c_tests/nist5
       Tests/w3c_tests/digtest"

XPLUS_TESTS_DIRS="
                  Tests/xplus_tests/choice
                  Tests/xplus_tests/choiceOfSeq
                  Tests/xplus_tests/scExt
                  Tests/xplus_tests/scExt2
                  Tests/xplus_tests/scExt3
                  Tests/xplus_tests/scExt4
                  Tests/xplus_tests/scRest
                  Tests/xplus_tests/scRest2
                  Tests/xplus_tests/scRest3
                  Tests/xplus_tests/scRest4
                  Tests/xplus_tests/netEnabled
                 " 


#EX_DIRS=
#W3C_TESTS_DIRS=
#XPLUS_TESTS_DIRS=


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
  CNT_FAILED_TESTS=`expr $CNT_FAILED_TESTS + 1`
  TEST_FAILED=true

  echo "   [ FAILED ]"
  #exit 2
}

pass_test()
{
  if [ $TEST_FAILED != 'true' ]; then
    CNT_PASSED_TESTS=`expr $CNT_PASSED_TESTS + 1`
    echo "   [ PASSED ]"
  fi
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
  echo "# cleaning up xplus_tests ..."
  echo "#------------------------------------------------------"
  for dir in $XPLUS_TESTS_DIRS
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
  

#  2 testcases
test_valid()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # check valid.xml exists
  if [ ! -f valid.xml ]; then
    echo "  valid.xml doesn't exist"
    fail_test
    return
  fi

  # validate valid.xml
  ./build/bin/$run -v valid.xml >> tests.log 2>&1
  if [ $? -ne 0 ]; then
    echo "   failed to validate valid.xml"
    fail_test
    return
  fi
}

#  1 testcase
test_build()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # verify that the dir builds
  xsd2cpp $input_xsd . >> tests.log 2>&1 && ./autogen.sh >> tests.log 2>&1 &&  make install >> tests.log 2>&1
  if [ $? -ne 0 ]; then
    echo "   failed to build"
    fail_test
    return
  fi
}

#  1 testcase
test_sample()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # write sample.xml
  ./build/bin/$run -s  >> tests.log 2>&1
  
  # check sample.xml exists
  if [ ! -f sample.xml ]; then
    echo "   sample.xml doesn't exist"
    fail_test
    return
  fi
}


#  2 testcases
test_write()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # write t.xml
  ./build/bin/$run -w  >> tests.log 2>&1
  
  # check t.xml exists
  if [ ! -f t.xml ]; then
    echo "   t.xml doesn't exist"
    fail_test
    return
  fi

  # verify diff
  differ=`diff t.xml valid.xml`
  if [ ! -z "$differ" ]; then
    echo "   failed to compare t.xml with valid.xml"
    fail_test
    return
  fi
}

#  2 testcases
test_roundtrip()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # rountrip
  ./build/bin/$run -r ./t.xml >> tests.log 2>&1
  
  # check t.xml.rt.xml exists
  if [ ! -f t.xml.rt.xml ]; then
    echo "   t.xml.rt.xml doesn't exist"
    fail_test
    return
  fi

  # verify diff
  differ=`diff t.xml.rt.xml t.xml`
  if [ ! -z "$differ" ]; then
    echo "   failed to compare t.xml.rt.xml with t.xml"
    fail_test
    return
  fi
}

# several testcases(8) are run in each test directory
# this functions does all the tests to be done, inside a particular test directory
test_dir()
{
  TEST_FAILED=false

  echo
  cd $dir 
  log_tests_dir
  
  > tests.log
  get_input_xsd
  echo "   input: $input_xsd"
  run=`basename $input_xsd | cut -d'.' -f1`run

  test_build
  test_valid
  test_sample
  test_write
  test_roundtrip

  pass_test
  cd - >/dev/null 2>&1
}

print_test_report()
{
  CNT_TOTAL_TESTS=`expr $CNT_PASSED_TESTS + $CNT_FAILED_TESTS`
  echo; echo
  echo "#-----------------------------------------"
  echo "            Test Report                  "
  echo "#-----------------------------------------"
  echo " Total Tests  : $CNT_TOTAL_TESTS" 
  echo " Passed Tests : $CNT_PASSED_TESTS" 
  echo " Failed Tests : $CNT_FAILED_TESTS" 
  if [ $CNT_FAILED_TESTS -eq 0 ]; then
    echo
    echo "        *** ALL TESTS PASSED ***       "
  fi
  echo "#-----------------------------------------"
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
  echo "# running tests on xplus_tests ..."
  echo "#------------------------------------------------------"
  for dir in $XPLUS_TESTS_DIRS
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
  

  print_test_report
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
