#!/bin/sh


ex_dirs="
        examples/org
        examples/includeDemo
        examples/helloWorld
        examples/helloWorldWide
        examples/mails
        examples/simpleTypesDemo
        examples/simplest
        examples/po"

w3c_tests_dirs="
       w3c_tests/stE080
       w3c_tests/stG003
       w3c_tests/stH005
       w3c_tests/stZ015
       w3c_tests/ste099
       w3c_tests/reDH7a
       w3c_tests/nist5
       w3c_tests/digtest"

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

cleanup_dir()
{
  cd $dir && find . | grep -v svn |grep -v README | grep -v xsd | grep -v xml | grep -v "main.cpp"  | xargs rm -rf 2>/dev/null
  rm -f *.template *.bak t.xml* sample.xml *.save
  cd -
  echo
  echo " * cleaned directory: $dir"  
}

cleanup()
{
  echo "cleaning up w3c_tests ..."
  for dir in $w3c_tests_dirs
  do
    cleanup_dir
  done

  echo "cleaning up examples ..."
  for dir in $ex_dirs
  do
    cleanup_dir
  done
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

test_dir()
{
  cd $dir 
  get_input_xsd
  echo "   input: $input_xsd"
  run=`basename $input_xsd | cut -d'.' -f1`run
  #cmd="xsd2cpp $input_xsd . && ./autogen.sh && make && make install && ./build/bin/$run -w"
  #ret=`$cmd > tests.log 2>&1`
 
  xsd2cpp $input_xsd . && ./autogen.sh && make && make install && ./build/bin/$run -w
  if [ $? -ne 0 ]; then
    echo "   *** build FAILED in dir: $dir"; exit 2
  else
    differ=`diff t.xml valid.xml`
    if [ ! -z "$differ" ]; then
      echo "   *** run FAILED in dir: $dir"; exit 2
    fi
    echo "   PASSED in dir: $dir "
  fi
  cd -
}


test_all()
{
  echo "running tests on w3c_tests ..."
  for dir in $w3c_tests_dirs
  do
    test_dir
  done


  echo "running tests on examples ..."
  for dir in $ex_dirs
  do
    test_dir
  done

  echo
  echo
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
      #cleanup
      test_all
      shift;;
    --)
      shift; break;;
  esac
done
