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

#include <sstream>
#include <string>
#include <vector>

#include "XPlus/StringUtils.h"
#include "XPlus/UString.h"

using namespace std;

namespace XPlus
{
  //specializations for bool
  template <> string toString (const bool& b)
  {
    std::ostringstream oss;
    oss << std::boolalpha << b;
    if (!oss) {
      throw StringException("toString failed");
    }
    return oss.str();
  }

  template <> string toString(const string& s)
  {
    return s;
  }

  template <> string toString(const UString& s)
  {
    return s.str();
  }

  template <> bool fromString<bool>(const string& s)
  {
    bool result;
    istringstream iss (s);
    iss >> std::boolalpha;
    if (iss >> result)
      return result;
  

    throw StringException(string("fromString failed. string:[") + s + "]");
  }


  template <> string fromString<string>(const string& s)
  {
    return s;
  }
  
  template <> UString fromString<UString>(const string& s)
  {
    return s;
  }


}// end namespace XPlus


