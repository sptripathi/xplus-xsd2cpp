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

