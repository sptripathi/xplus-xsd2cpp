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

#ifndef __DATETIME_H__
#define __DATETIME_H__

#include <iostream>
#include <sstream>

#include "XPlus/Duration.h"
#include "XPlus/TimeZone.h"

using namespace std;

namespace XPlus {

  class DateTime
  {
    public:

      static const TimeZone UTC_TZ;
      static const TimeZone UNKNOWN_TZ;
      
      static const int UNSPECIFIED;
      static const int INDETERMINATE;

      static const int MIN_VALID_YEAR;
      static const int MIN_VALID_MONTH;
      static const int MIN_VALID_DAY;
      static const int MIN_VALID_HOUR;
      static const int MIN_VALID_MINUTE;
      static const int MIN_VALID_SECOND;

      static const int MAX_VALID_YEAR;
      static const int MAX_VALID_MONTH;
      static const int MAX_VALID_DAY;
      static const int MAX_VALID_HOUR;
      static const int MAX_VALID_MINUTE;
      static const int MAX_VALID_SECOND;
      static const int MAX_VALID_TZ_HOUR;

      static const std::string ISO8601_FORMAT;
      static const std::string XSD_DATE_FORMAT;
      static const std::string XSD_DAY_FORMAT;
      static const std::string XSD_MONTH_FORMAT;
      static const std::string XSD_MONTHDAY_FORMAT;
      static const std::string XSD_YEARMONTH_FORMAT;
      static const std::string XSD_TIME_FORMAT;
      static const std::string XSD_DURATION_FORMAT;

      enum Months
      {
        JANUARY = 1,
        FEBRUARY,
        MARCH,
        APRIL,
        MAY,
        JUNE,
        JULY,
        AUGUST,
        SEPTEMBER,
        OCTOBER,
        NOVEMBER,
        DECEMBER
      };

      enum DaysOfWeek
      {
        SUNDAY = 0,
        MONDAY,
        TUESDAY,
        WEDNESDAY,
        THURSDAY,
        FRIDAY,
        SATURDAY
      };

      DateTime(int year=1, int month=1, int day=1, int hour = 0, int minute = 0, double second = 0, TimeZone tz=UNKNOWN_TZ);

      DateTime& assign(int year, int month, int day, int hour, int minute, double second, TimeZone tz=UNKNOWN_TZ);

      DateTime(const DateTime& dateTime);

      virtual ~DateTime();


      void swap(DateTime& dateTime);

      int year() const;
      int month() const;
      int day() const;
      int dayOfYear() const;
      int hour() const;
      bool isAM() const;
      bool isPM() const;
      int minute() const;
      double second() const;
      TimeZone timeZone() const;
      bool tzAvailable() const;
      bool isUTC() const;

      DateTime& operator += (const Duration& d);
      DateTime& operator -= (const Duration& d);
      DateTime& operator = (const DateTime& dateTime);
      bool operator == (const DateTime& dateTime) const;	
      bool operator != (const DateTime& dateTime) const;	
      bool operator <  (const DateTime& dateTime) const;	
      bool operator <= (const DateTime& dateTime) const;	
      bool operator >  (const DateTime& dateTime) const;	
      bool operator >= (const DateTime& dateTime) const;	

      void makeUTC();
      void makeUTC(TimeZone tz);
      void makeLocal(TimeZone tz);
      //double toSeconds();


      void print() const {
        cout << "DateTime: [ " 
          << "year=" << year()
          << " month=" << month()
          << " day=" << day()
          << " hour=" << hour()
          << " minute=" << minute()
          << " second=" << second()
          << " tz_hour=" << _tz.hour()
          << " tz_mins=" << _tz.minute()
          << " ]"
          << endl;
      }

      friend class DateTimeUtils;
    
    protected:

      DateTime& assign_nochecks(int year, int month, int day, int hour, int minute, double second, TimeZone tz=UNKNOWN_TZ);

    private:

      short  _year;
      short  _month;
      short  _day;
      short  _hour;
      short  _minute;
      double  _second;
      TimeZone    _tz; 
  };

  inline int DateTime::year() const {
    return _year;
  }

  inline int DateTime::month() const {
    return _month;
  }

  inline int DateTime::day() const {
    return _day;
  }

  inline int DateTime::hour() const {
    return _hour;
  }

  inline bool DateTime::isAM() const {
    return _hour < 12;
  }

  inline bool DateTime::isPM() const {
    return _hour >= 12;
  }

  inline int DateTime::minute() const {
    return _minute;
  }

  inline double DateTime::second() const {
    return _second;
  }

  inline TimeZone DateTime::timeZone() const {
    return _tz;
  }

  inline bool DateTime::tzAvailable() const {
    return (_tz != UNKNOWN_TZ);
  }

  inline bool DateTime::isUTC() const {
    return (_tz == UTC_TZ);
  }

} // namespace XPlus

XPlus::DateTime operator + (const XPlus::DateTime& dt, const XPlus::Duration& d);
XPlus::DateTime operator - (const XPlus::DateTime& dt, const XPlus::Duration& d);
XPlus::Duration operator - (const XPlus::DateTime& dt1, const XPlus::DateTime& dt2);

#endif 
