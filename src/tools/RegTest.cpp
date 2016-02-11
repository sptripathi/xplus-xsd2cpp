// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
//
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the 
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and to 
// permit persons to whom the Software is furnished to do so, subject to 
// the following conditions: 
// 
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
//

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
