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
#include "XPlus/Exception.h"
#include "XPlus/Base64Codec.h"

using namespace std;

// test utility for base64 encode/decode
int main()
{
  XPlus::Base64Codec base64Codec;
  string str = "";
  string breakStr = "" ;

  cout << endl;
  cout << "  * test base64 encode/decode(roundtrip) on subject strings" << endl;
  cout << "  * press [CTRL+N then enter] for ending a loop in the test" << endl;
  try
  {
    while(1)
    {
      cout << "(subject string) ";
      std::getline(cin, str);
      if(str == breakStr) {
        break;
      }
      string encodedStr = base64Codec.encode(str);
      cout  << "  base64 encoded string: [" << encodedStr << "]" << endl;
      cout  << "  base64 decoded string: [" << base64Codec.decode(encodedStr) << "]" << endl;
    }
  }
  catch(XPlus::Exception& ex) {
    cerr << "error:" << ex.msg() << endl;
  }

  return 1;
}
