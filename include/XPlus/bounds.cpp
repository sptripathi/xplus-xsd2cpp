// numeric_limits example
#include <iostream>
#include <limits>

#include "XPlus/Types.h"

using namespace std;

int checkBounds () {
  cout << boolalpha;
  
  cout << "Minimum value for short: " << numeric_limits<short>::min() << endl;
  cout << "Maximum value for short: " << numeric_limits<short>::max() << endl;
  
  cout << "Minimum value for Int32: " << numeric_limits<Poco::Int32>::min() << endl;
  cout << "Maximum value for Int32: " << numeric_limits<Poco::Int32>::max() << endl;
  
  cout << "Minimum value for UInt32: " << numeric_limits<Poco::UInt32>::min() << endl;
  cout << "Maximum value for UInt32: " << numeric_limits<Poco::UInt32>::max() << endl;
  
  cout << "Minimum value for longlong: " << numeric_limits<long long>::min() << endl;
  cout << "Maximum value for longlong: " << numeric_limits<long long>::max() << endl;
  
  cout << "Minimum value for Int64: " << numeric_limits<Poco::Int64>::min() << endl;
  cout << "Maximum value for Int64: " << numeric_limits<Poco::Int64>::max() << endl;
  
  cout << "Minimum value for UInt64: " << numeric_limits<Poco::UInt64>::min() << endl;
  cout << "Maximum value for UInt64: " << numeric_limits<Poco::UInt64>::max() << endl;

  cout << "int is signed: " << numeric_limits<int>::is_signed << endl;
  cout << "Non-sign bits in int: " << numeric_limits<int>::digits << endl;
  cout << "int has infinity: " << numeric_limits<int>::has_infinity << endl;


  cout << "int has_quiet_NaN: " << numeric_limits<int>::has_quiet_NaN << endl;
  int x = numeric_limits<int>::quiet_NaN();
  cout << "x=" << x << endl;

  return 0;
}




main()
{
  checkBounds();
}
