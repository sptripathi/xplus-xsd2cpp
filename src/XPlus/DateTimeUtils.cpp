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
#include <sstream>

#include <math.h>

#include "XPlus/DateTime.h"
#include "XPlus/Exception.h"
#include "XPlus/DateTimeUtils.h"
#include "XPlus/FPA.h"
#include "Poco/NumberFormatter.h"

using namespace std;
using namespace Poco;

namespace XPlus {

#define SKIP_PAST_DIGITS() \
  while (it != end && std::isdigit(*it)) ++it

#define SKIP_PAST_DECIMAL() \
  while (it != end && (std::isdigit(*it) || (*it=='.'))) ++it

#define SKIP_UNTIL_CHAR(c) \
  while (it != end && (*it!=c)) ++it

#define SKIP_JUNK() \
  while (it != end && !std::isdigit(*it)) ++it


#define PARSE_NUMBER(var) \
  while (it != end && std::isdigit(*it)) var = var*10 + ((*it++) - '0')


#define PARSE_NUMBER_N(var, n) \
  { int i = 0; while (i++ < n && it != end && std::isdigit(*it)) var = var*10 + ((*it++) - '0'); }

  void DateTimeUtils::parse(const std::string& fmt, const std::string& str, DateTime& dateTime)
  {
    int year   = DateTime::UNSPECIFIED;
    int month  = DateTime::UNSPECIFIED;
    int day    = DateTime::UNSPECIFIED;
    int hour   = DateTime::UNSPECIFIED;
    int minute = DateTime::UNSPECIFIED;
    double second = DateTime::UNSPECIFIED;
    TimeZone tz = DateTime::UNKNOWN_TZ;

    std::string::const_iterator it   = str.begin();
    std::string::const_iterator end  = str.end();
    std::string::const_iterator itf  = fmt.begin();
    std::string::const_iterator endf = fmt.end();

    while (itf != endf && it != end)
    {
      if (*itf == '%')
      {
        if (++itf != endf)
        {
          switch (*itf)
          {
            case 'w':
            case 'W':
              while (it != end && std::isspace(*it)) ++it;
              while (it != end && std::isalpha(*it)) ++it;
              break;
            case 'd':
              SKIP_JUNK();
              day = 0;
              PARSE_NUMBER_N(day, 2);
              break;
            case 'm':
            case 'n':
            case 'o':
              SKIP_JUNK();
              month = 0;
              PARSE_NUMBER_N(month, 2);
              break;					 
            case 'Y':
              SKIP_JUNK();
              year = 0;
              PARSE_NUMBER_N(year, 4);
              break;
            case 'H':
            case 'h':
              SKIP_JUNK();
              hour = 0;
              PARSE_NUMBER_N(hour, 2);
              break;
            case 'M':
              SKIP_JUNK();
              minute = 0;
              PARSE_NUMBER_N(minute, 2);
              break;
            case 'S':
              SKIP_JUNK();
              second = 0;
              PARSE_NUMBER_N(second, 2);
              break;
            case 's':
              {
                double significand;
                int exponent;
                SKIP_JUNK();
                std::string::const_iterator it_begin = it;
                SKIP_PAST_DECIMAL();
                std::string::const_iterator it_end = it;
                FPA::parseDecimal(str, it_begin, it_end, significand, exponent);
                second = significand*pow(10,exponent);
              }
              break;
            case 'z':
            case 'Z':
              {
                try {
                  tz = parseTZ(it, end);
                }
                catch(NotFoundException& ex) {
                  tz = DateTime::UNKNOWN_TZ;
                }
              }
              break;
          }
          ++itf;
        }
      }
      else ++itf;
    }
    dateTime.assign(year, month, day, hour, minute, second, tz);
  }


  DateTime DateTimeUtils::parse(const std::string& fmt, const std::string& str)
  {
    DateTime result;
    parse(fmt, str, result);
    return result;
  }

  DateTime DateTimeUtils::parseISO8601DateTime(const std::string& str)
  {
    DateTime result;
    parse(DateTime::ISO8601_FORMAT, str, result);
    return result;
  }
  
  Day DateTimeUtils::parseXsdDay(const std::string& str)
  {
    Day result;
    parse(DateTime::XSD_DAY_FORMAT, str, result);
    return result;
  }

  Month DateTimeUtils::parseXsdMonth(const std::string& str)
  {
    Month result;
    parse(DateTime::XSD_MONTH_FORMAT, str, result);
    return result;
  }

  MonthDay DateTimeUtils::parseXsdMonthDay(const std::string& str)
  {
    MonthDay result;
    parse(DateTime::XSD_MONTHDAY_FORMAT, str, result);
    return result;
  }

  YearMonth DateTimeUtils::parseXsdYearMonth(const std::string& str)
  {
    YearMonth result;
    parse(DateTime::XSD_YEARMONTH_FORMAT, str, result);
    return result;
  }

  Date DateTimeUtils::parseXsdDate(const std::string& str)
  {
    Date result;
    parse(DateTime::XSD_DATE_FORMAT, str, result);
    return result;
  }
      
  Time DateTimeUtils::parseXsdTime(const std::string& str)
  {
    Time result;
    parse(DateTime::XSD_TIME_FORMAT, str, result);
    return result;
  }

  
  Duration DateTimeUtils::parseXsdDuration(const std::string& str)
  {
    int year   = 0;
    int month  = 0;
    int day    = 0;
    int hour   = 0;
    int minute = 0;
    double second = 0;

    std::string::const_iterator it   = str.begin();
    std::string::const_iterator end  = str.end();

    int number=0;

    unsigned int cnt = 0;
    unsigned int cntPastT = 0;
    double fraction = 0;
    bool pastT=false;
    bool pastMonth=false;
    bool foundDot=false;

    poco_assert(str.length() >= 3); // P1Y
    // P(nY)?(nM)?(nD)?(T(nH)?(nM)?(nS)?)?
    // P1Y2M3DT10H30M40S
    poco_assert(*it == 'P'); ++it;
    string expect = "YMDTHMS";
      std::string::iterator it2   = expect.begin();

    for( ; it != end; ++it)
    {
      PARSE_NUMBER(number);
      if(*it == '.')
      {
        foundDot = true;
        std::string::const_iterator it_begin = it;
        ++it;
        SKIP_PAST_DIGITS();
        std::string::const_iterator it_end = it;
        
        double significand;
        int exponent;
        FPA::parseDecimal(str, it_begin, it_end, significand, exponent);
        fraction = significand*pow(10,exponent); 
      }

      //cout << "*it:" << *it << " number:" << number <<   " expect:" << expect << endl;
      std::string::iterator end2  = expect.end();
      while( (it2 != end2) && (*it2 != *it) )
      {
        ++it2;
      }
      if(it2 == end2) {
        throw DateTimeException("Duration parse error");
      }

      if(*it == 'T') {
        pastT = true;
        number=0;
        continue;
      }

      switch(*it)
      {
        case 'Y':
          year = number;
          break;
        case 'M':
          {
            if(pastT) {
              minute = number;
            }
            else {
              poco_assert(pastMonth == false);
              month = number;
            }
          }
          break;
        case 'D':
          day = number;
          break;
        case 'H':
          hour = number;
          poco_assert(pastT == true);
          break;
        case 'S':
          {
            poco_assert(pastT == true);
            second =  number + fraction;
          }
          break;
        default:
          throw DateTimeException("Duration parse error");
      }
      if(foundDot && (*it != 'S')) {
        throw DateTimeException("Duration parse error");
      }

      number=0;
      cnt++;
      if(pastT) cntPastT++;
    }
    if(!pastT & (cntPastT>0)) {
      throw DateTimeException("Duration parse error");
    }
    else if(pastT & (cntPastT==0)) {
      throw DateTimeException("Duration parse error");
    }
    if(cnt==0) {
      throw DateTimeException("Duration parse error");
    }

    Duration result;
    result.assign(year, month, day, hour, minute, second);
    return result;
  }


  TimeZone DateTimeUtils::parseTZ(std::string::const_iterator& it, const std::string::const_iterator& end)
  {
    int sign =1;
    int hours =0, minutes=0;
    while (it != end && std::isspace(*it)) ++it;
    if (it != end)
    {
      if (*it == 'Z') {
        hours =0;
        minutes =0;
      }
      else if (*it == '+' || *it == '-')
      {
        sign = *it == '+' ? 1 : -1;
        ++it;
        PARSE_NUMBER_N(hours, 2);
        if (it != end && *it == ':') ++it;
        PARSE_NUMBER_N(minutes, 2);
      }
      else {
        throw DateTimeException("Invalid TimeZone");
      }
    }
    else
    {
      throw NotFoundException("TimeZone info not found");
    }
    return TimeZone(hours, minutes, (sign==-1));
  }


  std::string DateTimeUtils::format(const DateTime& dateTime, const std::string& fmt)
  {
    std::string result;
    result.reserve(64);
    append(result, dateTime, fmt);
    return result;
  }

  std::string DateTimeUtils::formatISO8601DateTime(const DateTime& dateTime)
  {
    std::string result;
    result.reserve(64);
    append(result, dateTime, DateTime::ISO8601_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdDate(const Date& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_DATE_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdDay(const Day& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_DAY_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdMonth(const Month& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_MONTH_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdMonthDay(const MonthDay& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_MONTHDAY_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdYearMonth(const YearMonth& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_YEARMONTH_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdTime(const Time& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input, DateTime::XSD_TIME_FORMAT);
    return result;
  }

  std::string DateTimeUtils::formatXsdDuration(const Duration& input)
  {
    std::string result;
    result.reserve(64);
    append(result, input);
    return result;
  }

  void DateTimeUtils::append(std::string& str, const DateTime& dateTime, const std::string& fmt)
  {
    std::string::const_iterator it  = fmt.begin();
    std::string::const_iterator end = fmt.end();
    while (it != end)
    {
      if (*it == '%')
      {
        if (++it != end)
        {
          switch (*it)
          {
            case 'd': 
              {
                NumberFormatter::append0(str, dateTime.day(), 2);
              }
              break;
            case 'm':
              {
                NumberFormatter::append0(str, dateTime.month(), 2);
              }
              break;
            case 'y':
              {
                NumberFormatter::append0(str, dateTime.year() % 100, 2);
              }
              break;
            case 'Y': 
              {
                NumberFormatter::append0(str, dateTime.year(), 4);
              }
              break;
            case 'H': 
              {
                NumberFormatter::append0(str, dateTime.hour(), 2); 
              }
              break;
            case 'M':
              {
                NumberFormatter::append0(str, dateTime.minute(), 2);
              }
              break;
            case 'S':
              {
                NumberFormatter::append0(str, (short)(dateTime.second()), 2);
              }
              break;
            case 's': 
              {
                int integral = (int)(dateTime.second());
                double fraction = dateTime.second() - integral; 
                NumberFormatter::append0(str, integral, 2); 
                if(fraction > 0)
                {
                  string fracStr;
                  ostringstream oss;
                  oss << fraction;
                  fracStr = oss.str();
                  fracStr.erase(fracStr.begin());
                  str += fracStr; 
                }
              }
              break;
            case 'z': appendTzdISO(str, dateTime); break;
            default:  str += *it;
          }
          ++it;
        }
      }
      else str += *it++;
    }
  }

  void DateTimeUtils::appendTzdISO(std::string& str, DateTime dateTime)
  {
    TimeZone tz = dateTime.timeZone();
    if ( tz == DateTime::UNKNOWN_TZ) {
      return;
    }
    else if ( tz == DateTime::UTC_TZ) {
      str += 'Z';
    }
    else if ( !tz.negative() )
    {
      str += '+';
      NumberFormatter::append0(str, tz.hour(), 2);
      str += ':';
      NumberFormatter::append0(str, tz.minute(), 2);
    }
    else 
    {
      str += '-';
      NumberFormatter::append0(str, -tz.hour(), 2);
      str += ':';
      NumberFormatter::append0(str, -tz.minute(), 2);
    }
  }


  void DateTimeUtils::append(std::string& str, const Duration& duration)
  {
    std::string fmt = DateTime::XSD_DURATION_FORMAT;
    std::string::const_iterator it  = fmt.begin();
    std::string::const_iterator end = fmt.end();
    while (it != end)
    {
      if (*it == '%')
      {
        if (++it != end)
        {
          switch (*it)
          {
            case 'd': NumberFormatter::append(str, duration.day()); break;
            case 'm': NumberFormatter::append(str, duration.month()); break;
            case 'Y': NumberFormatter::append(str, duration.year()); break;
            case 'H': NumberFormatter::append(str, duration.hour()); break;
            case 'M': NumberFormatter::append(str, duration.minute()); break;
            case 's': NumberFormatter::append(str, duration.second()); break;
            default:  str += *it;
          }
          ++it;
        }
      }
      else str += *it++;
    }
  }


} // namespace XPlus

