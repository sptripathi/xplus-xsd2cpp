// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
