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


