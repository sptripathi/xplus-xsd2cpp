#!/bin/bash

CNT_TOTAL_TESTS=0
CNT_FAILED_TESTS=0
CNT_PASSED_TESTS=0

# xmllint core dumps, on certain schemas, dont use it in tests
XMLLINT=`which xmllint`
TEST_FAILED=false
FAILED_DIRS=""
INPUT_XSD=""

EX_DIRS=""
W3C_TESTS_DIRS=""
XPLUS_TESTS_DIRS=""
XPLUS_NEGTESTS_DIRS=""

ascertain_test_dirs()
{
  #W3C_TESTS_DIRS=`ls -1d Tests/w3c_tests/*`

  EX_DIRS=`find examples  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  #W3C_TESTS_DIRS=`find Tests/w3c_tests  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  #XPLUS_TESTS_DIRS=`find Tests/xplus_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  #XPLUS_NEGTESTS_DIRS=`find Tests/xplus_neg_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
}

print_usage()
{
  echo
  echo "Usage:"
  echo "$ `basename $0`  [-c | -t]"
  echo "    -c  cleanup all the test directories"
  echo "    -t  cleanup and test all the test directories"
  echo "    -h  print help"
  echo
  echo " (test directories include: Tests/ examples/) "
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

get_INPUT_XSD()
{
  INPUT_XSD=`ls -1 *.xsd`
  cnt_xsds=`echo "$INPUT_XSD" | wc -l | sed -e 's/ *//g'`
  if [ $cnt_xsds -ne 1 ]; then
    if [ -f README ]; then
      INPUT_XSD=`cat README | grep INPUT_XSD | cut -d= -f2 | sed -e 's/ *//g'`
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
  FAILED_DIRS="$FAILED_DIRS $dir"

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
  find . | grep -v svn | grep -v README | grep -v xsd | grep -v xml | grep -v testme | grep -v "main.cpp"  | xargs rm -rf 2>/dev/null 
  rm -f *.template *.bak t.xml* *.xml.rt.xml *.xml.row.xml sample.xml *.save README.build.txt 
  cd - > /dev/null 2>&1
  echo "   [ CLEANED ]"  
}

cleanup()
{
  echo
  echo "  =========================  WARNING ============================"
  echo "  Requested execution will cleanup many files recursively inside"
  echo "  certain directories, so that any of user added files and edits"
  echo "  may get lost. If you think you have added/edited important "
  echo "  changes inside these directories, please back them up, before"
  echo "  proceeding."
  echo
  echo "  Following directories would get cleaned up recursively:"
  echo "  * Tests/ "
  echo "  * examples/"
  echo 
  echo -n "Do you want to continue [y/N]? "
  read ans
  if [ "$ans" != 'y' ]; then
    echo  "  => aborting the execution..."
    echo
    exit 2
  fi


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
  echo "# cleaning up xplus_neg_tests ..."
  echo "#------------------------------------------------------"
  for dir in $XPLUS_NEGTESTS_DIRS
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
  

test_valid()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  validXmlFiles=`ls valid*.xml 2>/dev/null`
  # validate valid.xml
  for xmlValid in $validXmlFiles
  do
    ./build/bin/$run -v $xmlValid >> tests.log 2>&1
    if [ $? -ne 0 ]; then
      echo "   failed to validate valid xml file: $xmlValid"
      fail_test
      return
    fi
  done

 #if [ ! -z  "$XMLLINT" ]; then
 #  $XMLLINT --noout --schema $INPUT_XSD valid.xml > /dev/null 2>&1 
 #  if [ $? -ne 0 ]; then
 #    echo "  failed to validate valid.xml using xmllint"
 #    #fail_test
 #    #return
 #  fi
 #fi
}

test_invalid()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  invalidXmlFiles=`ls invalid*.xml 2>/dev/null`
  # invalidate invalid[N].xml
  for xmlInvalid in $invalidXmlFiles
  do
    ./build/bin/$run -v $xmlInvalid >> tests.log 2>&1
    if [ $? -eq 0 ]; then
      echo "   failed to invalidate invalid xml file: $xmlInvalid"
      fail_test
      return
    fi
  done
}



#  1 testcase
test_build()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # verify that the dir builds
  xsd2cpp $INPUT_XSD . >> tests.log 2>&1 && ./autogen.sh >> tests.log 2>&1 &&  make install >> tests.log 2>&1
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
    echo "   failed to write sample.xml"
    fail_test
    return
  fi

  #./build/bin/$run -v sample.xml >> tests.log 2>&1
  #if [ $? -ne 0 ]; then
  #  echo "   failed to validate file: sample.xml"
  #  fail_test
  #  return
  #fi
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
    echo "   failed to write t.xml"
    fail_test
    return
  fi

  # verify diff
  #differ=`diff t.xml valid.xml`
  #if [ ! -z "$differ" ]; then
  #  echo "   failed to compare t.xml with valid.xml"
  #  fail_test
  #  return
  #fi
}

#  2 testcases
test_roundtrip()
{
  if [ $TEST_FAILED = 'true' ]; then
    return
  fi

  # rountrip
  validXmlFiles=`ls valid*.xml` 2>/dev/null
  for xmlValid in $validXmlFiles
  do
    ./build/bin/$run -r $xmlValid >> tests.log 2>&1
    # check xyz.xml.rt.xml exists
    if [ ! -f $xmlValid.rt.xml ]; then
      echo "   failed to roundtrip input file [$xmlValid] to write roundtripped file [$xmlValid.rt.xml]"
      fail_test
      return
    fi
  done

  # ROW: rountrip with callback
  for xmlValid in $validXmlFiles
  do
    ./build/bin/$run -u $xmlValid >> tests.log 2>&1
    # check xyz.xml.row.xml exists
    if [ ! -f $xmlValid.row.xml ]; then
      echo "   failed to roundtrip input file [$xmlValid] to write roundtripped file [$xmlValid.row.xml]"
      fail_test
      return
    fi
  done

  # verify diff
  #differ=`diff t.xml.rt.xml t.xml`
  #if [ ! -z "$differ" ]; then
  #  echo "   failed to compare t.xml.rt.xml with t.xml"
  #  fail_test
  #  return
  #fi
}

neg_test_dir()
{
  echo
  cd $dir 
  log_tests_dir

  xsd2cpp $INPUT_XSD . >> tests.log 2>&1 
  if [ $? -eq 0 ]; then
    echo "   failed because xsd2cpp succeeded"
    fail_test
    return
  fi
  
  pass_test
  cd - >/dev/null 2>&1
}

# several testcases are run in each test directory
# this functions does all the tests to be done, inside
# a particular test directory
test_dir()
{
  echo
  cd $dir 
  log_tests_dir
  > tests.log

  if [ -f testme ]; then
    echo "     ->running custom tests"
    ./testme >> tests.log 2>&1
    if [ $? -ne 0 ]; then
      fail_test  
    fi
  else  
    get_INPUT_XSD
    echo "   input: $INPUT_XSD"
    run=`basename $INPUT_XSD | cut -d'.' -f1 |sed -e 's/-/_/g'`run
    #run=`basename $INPUT_XSD | cut -d'.' -f1`run
    TEST_FAILED=false
    test_build
    test_valid
    test_invalid
    #test_sample
    test_write
    test_roundtrip
  fi

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
  else
    echo " tests failed : $FAILED_DIRS"
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



  echo "#------------------------------------------------------"
  echo "# running tests on xplus_neg_tests ..."
  echo "#------------------------------------------------------"
  for dir in $XPLUS_NEGTESTS_DIRS
  do
    neg_test_dir
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
      shift;break;;
    -c)
      ascertain_test_dirs
      cleanup
      shift;break;;
    -t)
      ascertain_test_dirs
      cleanup
      echo;echo
      test_all
      shift;break;;
    --)
      print_usage
      shift; break;;
  esac
done
