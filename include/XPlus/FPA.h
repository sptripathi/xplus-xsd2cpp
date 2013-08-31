// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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

#ifndef __XPLUS_FPA_H__
#define __XPLUS_FPA_H__

#include "string"
#include "XPlus/Types.h"

using namespace std;

namespace XPlus
{
  namespace FPA
  {
    void parseDecimal(const std::string& str,
        std::string::const_iterator& it,
        std::string::const_iterator& it_end,
        double& significand,
        int& exponent
        );

    void interpretDecimal(double significand, 
        double exponent,
        int & integral,
        int& millis,
        int& micros
        );

    unsigned int countFractionDigits(const double& d);
    unsigned int countFractionDigits(const string& doubleStr);

    unsigned int countIntegralDigits(const double& d);
    unsigned int countIntegralDigits(const string& doubleStr);

    void countIntegralAndFractionDigits(const double& d, 
                                        unsigned int& integralDigits, 
                                        unsigned int& fractionalDigits);
    void countIntegralAndFractionDigits(const string& doubleStr, 
                                        unsigned int& integralDigits, 
                                        unsigned int& fractionalDigits);

    unsigned int countTotalDigits(const double& d);
    unsigned int countTotalDigits(const string& doubleStr);

  }
}

#endif
