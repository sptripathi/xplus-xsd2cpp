#include <iostream>
#include <string>
#include "Poco/RegularExpression.h"
#include "Poco/Exception.h"

using namespace std;

// test utility for perl-compatible regular expression
int main()
{
  string str = "", pattern= ".*";
  string breakStr = "" ;

  cout << endl;
  cout << "  * test perl-compatible regular expressions against subject strings" << endl;
  cout << "  * press [CTRL+N then enter] for ending a loop in the test" << endl;
  while(1)
  {
    cout  << endl << "(regex) ";
    std::getline(cin, pattern);
    if(pattern == breakStr) {
      break;
    }
    try
    {
      Poco::RegularExpression re(pattern);
      while(1)
      {
        cout << "  (subject) ";
        std::getline(cin, str);
        if(str == breakStr) {
          break;
        }
        if(re.match(str)) {
          cout  << "            => matched " << endl;
        }
        else {
          cerr  << "            => NO MATCH" << endl;
        }
      }
    }
    catch(Poco::Exception& ex) {
      cerr << "error:" << ex.message() << endl;
    }
  }

  return 1;
}
