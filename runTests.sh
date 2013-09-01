#!/bin/bash

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

  EX_DIRS=`find examples  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  W3C_TESTS_DIRS=`find Tests/w3c_tests  -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  XPLUS_TESTS_DIRS=`find Tests/xplus_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  XPLUS_NEGTESTS_DIRS=`find Tests/xplus_neg_tests -maxdepth 1 -mindepth 1 -type d | grep -v "svn*"`
  
	TESTS_DIRS="$EX_DIRS $W3C_TESTS_DIRS $XPLUS_TESTS_DIRS"
	NEG_TESTS_DIRS="$XPLUS_NEGTESTS_DIRS"
  ALL_DIRS="$TESTS_DIRS $NEG_TESTS_DIRS"
}

change_dir_abort()
{
  cd $dir 
  if [ $? -ne 0 ]; then
    echo "failed to change-dir: $dir" >> $LOG_FILE
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

log_tests_dir()
{
  LOG_FILE_DIR=$TEST_REPORT_DIR/logs
  mkdir -p $LOG_FILE_DIR
  LOG_FILE=$LOG_FILE_DIR/`basename $dir`.log
  echo $dir >> $LOCK_FILE
}

fail_test()
{
  TEST_FAILED=true
	echo $dir >> $FAILED_REPORT
}

pass_test()
{
  if [ $TEST_FAILED != 'true' ]; then
		echo $dir >> $PASSED_REPORT
  fi
}

cleanup_dir()
{
  change_dir_abort
  find . | grep -v svn | grep -v README | grep -v xsd | grep -v xml | grep -v testme | grep -v "main.cpp"  | xargs rm -rf 2>/dev/null 
  rm -f *.template *.bak t.xml* *.xml.rt.xml *.xml.row.xml sample.xml *.save README.build.txt 
  cd - > /dev/null 2>&1
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

  echo
  echo
  echo "=> Starting..."
  echo "=> Cleaning..."

  for dir in $TESTS_DIRS
  do
    cleanup_dir
  done
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
    ./build/bin/$run -v $xmlValid >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
      echo "   failed to validate valid xml file: $xmlValid" >> $LOG_FILE
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
    ./build/bin/$run -v $xmlInvalid >> $LOG_FILE 2>&1
    if [ $? -eq 0 ]; then
      echo "   failed to invalidate invalid xml file: $xmlInvalid" >> $LOG_FILE
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
  xsd2cpp $INPUT_XSD . >> $LOG_FILE 2>&1 && ./autogen.sh >> $LOG_FILE 2>&1 &&  make install >> $LOG_FILE 2>&1
  if [ $? -ne 0 ]; then
    echo "   failed to build" >> $LOG_FILE
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
  ./build/bin/$run -s  >> $LOG_FILE 2>&1
  
  # check sample.xml exists
  if [ ! -f sample.xml ]; then
    echo "   failed to write sample.xml" >> $LOG_FILE
    fail_test
    return
  fi

  #./build/bin/$run -v sample.xml >> $LOG_FILE 2>&1
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
  ./build/bin/$run -w  >> $LOG_FILE 2>&1
  
  # check t.xml exists
  if [ ! -f t.xml ]; then
    echo "   failed to write t.xml" >> $LOG_FILE
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
    ./build/bin/$run -r $xmlValid >> $LOG_FILE 2>&1
    # check xyz.xml.rt.xml exists
    if [ ! -f $xmlValid.rt.xml ]; then
      echo "   failed to roundtrip input file [$xmlValid] to write roundtripped file [$xmlValid.rt.xml]" >> $LOG_FILE
      fail_test
      return
    fi
  done

  # ROW: rountrip with callback
  for xmlValid in $validXmlFiles
  do
    ./build/bin/$run -u $xmlValid >> $LOG_FILE 2>&1
    # check xyz.xml.row.xml exists
    if [ ! -f $xmlValid.row.xml ]; then
      echo "   failed to roundtrip input file [$xmlValid] to write roundtripped file [$xmlValid.row.xml]" >> $LOG_FILE
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

  get_INPUT_XSD
  xsd2cpp $INPUT_XSD . >> $LOG_FILE 2>&1 
  if [ $? -eq 0 ]; then
    echo "   failed because xsd2cpp succeeded" >> $LOG_FILE
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
  cd $dir 
  log_tests_dir

  if [ -f testme ]; then
    echo "     ->running custom tests" >> $LOG_FILE
    ./testme >> $LOG_FILE 2>&1
    if [ $? -ne 0 ]; then
      fail_test  
    fi
  else  
    get_INPUT_XSD
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

wait_for_lock()
{
  while [ -f $LOCK_FILE ]
  do
    sleep 1  
  done
}

# need not be atomic, as it is 1) based on understanding within this script 2) lock violations causes no loss
acquire_lock()
{
  wait_for_lock
  touch $LOCK_FILE
}

release_lock()
{
  rm -f $LOCK_FILE
}

wait_for_children_to_finish()
{
  for job in `jobs -p`
  do
    wait $job || let "FAIL+=1"
  done
}

test_dirs_in_buffer()
{
  acquire_lock

  for dir in $DIR_BUFFER_4_TEST
  do
    if [ $NEG = 0 ]; then
      echo "./runTests.sh -p $dir & "
      ./runTests.sh -p $dir &
    else
      echo "./runTests.sh -n $dir & "
      ./runTests.sh -n $dir &
    fi
  done

  wait_for_children_to_finish
  release_lock
}

test_all()
{
  echo "=> Running tests ..."
  echo 

  DIR_BUFFER_4_TEST="" 
  count=0

  # ---------------- 
  for dir in $TESTS_DIRS
  do
    count=`expr $count + 1`
    DIR_BUFFER_4_TEST="$DIR_BUFFER_4_TEST $dir"
    if [ $count -eq 2 ]; then
      test_dirs_in_buffer
      count=0
      DIR_BUFFER_4_TEST=""
    fi 
  done
  # for the odd one  
  if [ $count -eq 1 ]; then
      test_dirs_in_buffer
      count=0
      DIR_BUFFER_4_TEST=""
  fi 


  # ---------------- 
  DIR_BUFFER_4_TEST="" 
  count=0
  NEG=1
  NEG_TESTS_DIRS="Tests/xplus_neg_tests/scRest Tests/xplus_neg_tests/scRest2"
  for dir in $NEG_TESTS_DIRS
  do
    count=`expr $count + 1`
    DIR_BUFFER_4_TEST="$DIR_BUFFER_4_TEST $dir"
    if [ $count -eq 2 ]; then
      test_dirs_in_buffer
      count=0
      DIR_BUFFER_4_TEST=""
    fi 
  done
  # for the odd one  
  if [ $count -eq 1 ]; then
      test_dirs_in_buffer
      count=0
      DIR_BUFFER_4_TEST=""
  fi 
  
  # ---------------- 

  wait_for_children_to_finish

  for job in `jobs -p`
  do
    wait $job || let "FAIL+=1"
  done

	echo "==========================================================="
  echo
	echo "          ................ [FAILED] ...............        "
  cat $FAILED_REPORT
  echo
  echo
  echo
	echo "          ................ [PASSED] ...............        "
  cat $PASSED_REPORT
  echo
	echo "==========================================================="

  rm -f $LOCK_FILE 
}

init_reports()
{
  rm -f $LOCK_FILE
	rm -rf $TEST_REPORT_DIR
  mkdir -p $TEST_REPORT_DIR
	>$FAILED_REPORT
	>$PASSED_REPORT
}


print_usage()
{
  echo
  echo "Usage:"
  echo "$ `basename $0`  [-c | -t ]"
  echo "    -c  cleanup all the test directories"
  echo "    -t  cleanup and test all the test directories"
  echo "    -h  print help"
  echo
  echo " (test directories include: Tests/ examples/) "
  echo
  exit 2
}




#-----------------------------------------------------------------
# MAIN

PID=$$
FAIL=0
TEST_REPORT_DIR=`pwd`/.TESTS
LOCK_FILE=$TEST_REPORT_DIR/xmlplus.lock
FAILED_REPORT=$TEST_REPORT_DIR/failed.txt
PASSED_REPORT=$TEST_REPORT_DIR/passed.txt
LOG_FILE=""
NEG=0

if [ $# = 0 ]; then
  print_usage
  exit 2
fi


while getopts "chtp:n:" op; 
  do
    case "${op}" in
    h)
      print_usage
      shift;break;;
    c)
      ascertain_test_dirs
      cleanup
      shift;break;;
    p)
      dir=$OPTARG
      test_dir
      shift;break;;
    n)
      dir=$OPTARG
      neg_test_dir
      shift;break;;
    t)
      ascertain_test_dirs
      cleanup
      init_reports
      test_all
      shift;break;;
    *)
      print_usage
      shift; break;;
    esac
  done
shift $((OPTIND-1))
















