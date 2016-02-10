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

#ifndef __XSD_ENUMS_H__
#define __XSD_ENUMS_H__ 

#include <string>

//FIXME: move into some commom .h file
#include "XPlus/DateTimeUtils.h"
#include "XPlus/DateTime.h"
#include "XPlus/Date.h"
#include "XPlus/Day.h"
#include "XPlus/Month.h"
#include "XPlus/MonthDay.h"
#include "XPlus/YearMonth.h"
#include "XPlus/Year.h"
#include "XPlus/Time.h"


using namespace std;

namespace XMLSchema
{
    enum ePrimitiveDataType
    {
      PD_STRING =0,
      PD_BOOLEAN,
      PD_DECIMAL,
      PD_FLOAT,
      PD_DOUBLE,
      PD_DURATION,
      PD_DATETIME,
      PD_TIME,
      PD_DATE,
      PD_GYEARMONTH,
      PD_GYEAR,
      PD_GMONTHDAY,
      PD_GDAY,
      PD_GMONTH,
      PD_HEXBINARY,
      PD_BASE64BINARY,
      PD_ANYURI,
      PD_QNAME,
      PD_NOTATION
    };
#define COUNT_PRIMITIVES  19

    enum eBuiltinDerivedType
    {
      BD_NONE      =0,
      BD_NORMALIZEDSTRING,
      BD_TOKEN,
      BD_LANGUAGE,
      BD_NMTOKEN,
      BD_NMTOKENS,
      BD_NAME,
      BD_NCNAME,
      BD_ID,
      BD_IDREF,
      BD_IDREFS,
      BD_ENTITY,
      BD_ENTITIES,
      BD_INTEGER,
      BD_NONPOSITIVEINTEGER,
      BD_NEGATIVEINTEGER,
      BD_LONG,
      BD_INT,
      BD_SHORT,
      BD_BYTE,
      BD_NONNEGATIVEINTEGER,
      BD_UNSIGNEDLONG,
      BD_UNSIGNEDINT,
      BD_UNSIGNEDSHORT,
      BD_UNSIGNEDBYTE,
      BD_POSITIVEINTEGER
    };


    extern const char* g_primitivesStr[COUNT_PRIMITIVES];


  // NB:
  // Here enums values are chosen as bit values to 
  // facilitate bit-masking.
  // To set all 12 bits you need dec 4095 ie 0xFFF
  enum eConstrainingFacets
  {
    CF_NONE           = 0,
    CF_LENGTH         = 1,
    CF_MINLENGTH      = 2,
    CF_MAXLENGTH      = 4,
    CF_PATTERN        = 8,
    CF_ENUMERATION    = 16,
    CF_WHITESPACE     = 32,
    CF_MAXINCLUSIVE   = 64,
    CF_MAXEXCLUSIVE   = 128,
    CF_MINEXCLUSIVE   = 256,
    CF_MININCLUSIVE   = 512,
    CF_TOTALDIGITS    = 1024,
    CF_FRACTIONDIGITS = 2048,
    CF_ALL            = 0xFFF  //  1111 1111 1111 
  };
#define COUNT_CFACETS  12

  struct BuitinTypesUnion 
  {
    float                floatValue;
    double               doubleValue;
    XPlus::DateTime       dateTimeValue;

  };


  extern const char* g_constrainingCFacetsStr[COUNT_CFACETS]; 

  string enumToStringCFacet(eConstrainingFacets facetType);
} // end namespace XMLSchema

#endif
