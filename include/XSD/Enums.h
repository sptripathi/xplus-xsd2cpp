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
