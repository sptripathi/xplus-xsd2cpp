// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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
