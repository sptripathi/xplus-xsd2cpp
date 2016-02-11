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

#include "XSD/Enums.h"

namespace XMLSchema
{
    const char* g_primitivesStr[COUNT_PRIMITIVES] = 
    {
      "string",
      "boolean",
      "decimal",
      "float",
      "double",
      "duration",
      "dateTime",
      "time",
      "date",
      "gYearMonth",
      "gYear",
      "gMonthDay",
      "gDay",
      "gMonth",
      "hexBinary",
      "base64Binary",
      "anyURI",
      "QName",
      "NOTATION"
    };

  const char* g_constrainingCFacetsStr[COUNT_CFACETS] = 
  {
    "length",
    "minLength",
    "maxLength",
    "pattern",
    "enumeration",
    "whiteSpace",
    "maxInclusive",
    "maxExclusive",
    "minExclusive",
    "minInclusive",
    "totalDigits",
    "fractionDigits"
  };

  string enumToStringCFacet(eConstrainingFacets facetType)
  {
    for(unsigned int i=0; i<COUNT_CFACETS; ++i)
    {
      if( facetType & (1<<i) ) {
        return g_constrainingCFacetsStr[i];
      }
    }
    return "Unknown CFacet";
  }


} // end namespace XMLSchema

