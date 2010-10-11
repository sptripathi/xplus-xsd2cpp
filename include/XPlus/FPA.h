// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Free Software Foundation, Inc.
// Author: Satya Prakash Tripathi
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


#ifndef __XPLUS_FPA_H__
#define __XPLUS_FPA_H__

#define ABS(X) ( ((X)<0)? -(X) : (X) )

namespace XPlus
{
  struct FPA
  {
    static void parseDecimal(const std::string& str,
        std::string::const_iterator& it,
        std::string::const_iterator& it_end,
        double& significand,
        int& exponent
        );
    static void interpretDecimal(double significand, 
        double exponent,
        int & integral,
        int& millis,
        int& micros
        );
  };
}

#endif
