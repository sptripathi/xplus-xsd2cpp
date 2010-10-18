// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <cctype>
#include <iostream>
#include <sstream>
#include <math.h>

#include "XPlus/FPA.h"
#include "XPlus/Exception.h"

using  namespace std;

namespace XPlus
{
  // 0.123456789
  void FPA::interpretDecimal(double significand, 
      double exponent,
      int & integral,
      int& millis,
      int& micros
      )
  {
    double fpn = significand*pow(10, exponent); 
    integral = fpn;
    double fraction = fpn - integral;
    millis = fraction*1000;
    micros = fraction*1000000 - millis*1000; 
    
    cout << "integral:" << integral 
      << " millis:" <<  millis 
      << " micros:" <<  micros 
      << endl;

  }

   void FPA::parseDecimal(const std::string& str, 
      std::string::const_iterator& it,
      std::string::const_iterator& it_end,
      double& significand,
      int& exponent
      )
  {
    char sign = 1;
    double var = 0;
    bool foundDot = false;
    exponent = 0;

    if(*it == '-') {
      sign = -1;
      ++it;
    }

    for (; it != it_end; ++it) 
    {
      if(std::isdigit(*it)) 
      {
        if(foundDot) exponent--;
        var = var*10 + (*it - '0');
      }
      else if(*it == '.') 
      {
        if(!foundDot) {
          foundDot = true;
        }
        else {
          throw Exception("parseDecimal: found unexpected '.'");
          cout << "A" << endl;
        }
      }
      // dont expect anything else except digits and a dot
      else 
      {
        ostringstream oss;
        oss << "parseDecimal: found unexpected '" << *it << "'";
          cout << "B" << endl;
        throw Exception(oss.str());
      }
    }

    significand =  sign*var;
  }
}

