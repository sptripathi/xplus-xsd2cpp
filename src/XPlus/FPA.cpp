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

#include <cctype>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <math.h>

#include "XPlus/FPA.h"
#include "XPlus/Exception.h"

using  namespace std;

#define PRECISION 10

namespace XPlus
{
  namespace FPA
  {
    // 0.123456789
    void interpretDecimal(double significand, 
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

      //cout << "integral:" << integral 
      //  << " millis:" <<  millis 
      //  << " micros:" <<  micros 
      //  << endl;

    }

    void parseDecimal(const std::string& str, 
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
          }
        }
        // dont expect anything else except digits and a dot
        else 
        {
          ostringstream oss;
          oss << "parseDecimal: found unexpected '" << *it << "'";
          throw Exception(oss.str());
        }
      }

      significand =  sign*var;
    }

    unsigned int countFractionDigits(const double& d)
    {
      string doubleStr;
      string fracDigitsStr;
      stringstream ss;
      ss << setprecision(PRECISION) << ABS(d);
      doubleStr = ss.str();

      fracDigitsStr = doubleStr.substr(doubleStr.find(".")+1);
      return fracDigitsStr.length();
    }
    
    unsigned int countFractionDigits(const string& doubleStr)
    {
      unsigned int cntFractionDigits = 0;
      string::size_type pos = doubleStr.find('.');
      if(pos == string::npos) {
        return 0;
      }
      for(unsigned int i=pos; i<doubleStr.length(); i++)
      {
        if(isdigit(doubleStr[i])) {
          cntFractionDigits++;
        }
      }
      return cntFractionDigits;
    }

    unsigned int countIntegralDigits(const double& d)
    {
      Int64 integralValue = static_cast<Int64>(ABS(d));
      string integralStr;
      stringstream ss;
      ss << integralValue;
      integralStr = ss.str();
      return integralStr.length();
    }

    unsigned int countIntegralDigits(const string& doubleStr)
    {
      unsigned int cntIntegralDigits = 0;
      string::size_type pos = doubleStr.find('.');
      if(pos == string::npos) {
        return countTotalDigits(doubleStr);
      }
      for(unsigned int i=0; i<pos; i++)
      {
        if(isdigit(doubleStr[i])) {
          cntIntegralDigits++;
        }
      }
      return cntIntegralDigits;
    }

    void countIntegralAndFractionDigits(const double& d, 
        unsigned int& integralDigits, 
        unsigned int& fractionalDigits)
    {
      integralDigits = countIntegralDigits(d);
      fractionalDigits = countFractionDigits(d);
    }

    void countIntegralAndFractionDigits(const string& doubleStr, 
        unsigned int& integralDigits, 
        unsigned int& fractionalDigits)
    {
      integralDigits = countIntegralDigits(doubleStr);
      fractionalDigits = countFractionDigits(doubleStr);
    }

    unsigned int countTotalDigits(const double& d)
    {
      unsigned int integralDigits, fractionalDigits;
      countIntegralAndFractionDigits(d, integralDigits, fractionalDigits);
      return (integralDigits + fractionalDigits);
    }
    
    unsigned int countTotalDigits(const string& doubleStr)
    {
      unsigned int cntTotalDigits=0;
      for(unsigned int i=0; i<doubleStr.length(); i++)
      {
        if(isdigit(doubleStr[i])) {
          cntTotalDigits++;
        }
      }
      return cntTotalDigits;
    }

  }
}

