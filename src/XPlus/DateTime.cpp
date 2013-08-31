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

#include <iostream>
#include <algorithm>
#include <cmath>

#include "Poco/Bugcheck.h"

#include "XPlus/DateTime.h"
#include "XPlus/DateAlgo.h"
#include "XPlus/Exception.h"

using namespace std;
using namespace XPlus::DateAlgo;

namespace XPlus {

  //
  // Timezones currently in use, could vary from +12:00 to -13:00. 
  // It is, however, possible for this range to expand or contract in the
  // future, based on local laws. 
  //
  const TimeZone DateTime::UTC_TZ = TimeZone(); //FIXME
  const TimeZone DateTime::UNKNOWN_TZ = TimeZone(24, 0);
  
  const int DateTime::UNSPECIFIED = -9999; //FIXME
  const int DateTime::INDETERMINATE = 2;

  // [0, ]
  const int DateTime::MIN_VALID_YEAR = 1;
  const int DateTime::MAX_VALID_YEAR = 99999; //FIXME

  // [1,12]
  const int DateTime::MIN_VALID_MONTH = 1;
  const int DateTime::MAX_VALID_MONTH = 12;
  
  // [1,31]
  const int DateTime::MIN_VALID_DAY = 1; 
  const int DateTime::MAX_VALID_DAY = 31; 
  
  // [0,24]
  const int DateTime::MIN_VALID_HOUR = 0 ; 
  const int DateTime::MAX_VALID_HOUR = 24 ; 

  // [0,59]
  const int DateTime::MIN_VALID_MINUTE = 0;
  const int DateTime::MAX_VALID_MINUTE = 59;

  // [0,60]
  const int DateTime::MIN_VALID_SECOND = 0;
  const int DateTime::MAX_VALID_SECOND = 60;
 
  // [0,14]:[0:60]
  const int DateTime::MAX_VALID_TZ_HOUR = 14;

  const std::string DateTime::ISO8601_FORMAT  = "%Y-%m-%dT%H:%M:%s%z";
  const std::string DateTime::XSD_DATE_FORMAT  = "%Y-%m-%d%z";
  const std::string DateTime::XSD_DAY_FORMAT  = "%d%z";
  const std::string DateTime::XSD_MONTH_FORMAT  = "%m%z";
  const std::string DateTime::XSD_MONTHDAY_FORMAT  = "%m-%d%z";
  const std::string DateTime::XSD_YEARMONTH_FORMAT  = "%Y-%m%z";
  const std::string DateTime::XSD_TIME_FORMAT  = "%H:%M:%s%z";
  const std::string DateTime::XSD_DURATION_FORMAT  = "P%YY%mM%dDT%HH%MM%sS"; //PnYnMnDTnHnMnS


  DateTime::DateTime(int year, int month, int day, int hour, int minute, double second, TimeZone tz):
    _year   (year),
    _month  (month),
    _day    (day),
    _hour   (hour),
    _minute (minute),
    _second (second),
    _tz(tz)
  {
    if(!DateAlgo::isValidDateTime(year, month, day, 
          hour, minute, second, tz))
    {
      ostringstream oss;
      oss << "Invalid date:"
        << " year:" << year
        << " month:" << month
        << " day:" << day
        << " hour:" << hour
        << " minute:" << minute
        << " second:" << second;

      throw DateTimeException(oss.str());
    }
  }
  
  DateTime& DateTime::assign_nochecks(int year, int month, int day, int hour, int minute, double second, TimeZone tz)
  {
    _year        = year;
    _month       = month;
    _day         = day;
    _hour        = hour;
    _minute      = minute;
    _second      = second;
    _tz         = tz;
    return *this;
  }

  DateTime& DateTime::assign(int year, int month, int day, int hour, int minute, double second, TimeZone tz)
  {
    if(!DateAlgo::isValidDateTime(year, month, day, 
          hour, minute, second, tz))
    {
      ostringstream oss;
      oss << "Invalid date:"
        << " year:" << year
        << " month:" << month
        << " day:" << day
        << " hour:" << hour
        << " minute:" << minute
        << " second:" << second;
      throw DateTimeException(oss.str());
    }

    _year        = year;
    _month       = month;
    _day         = day;
    _hour        = hour;
    _minute      = minute;
    _second      = second;
    _tz         = tz;
    return *this;
  }

  DateTime::DateTime(const DateTime& dateTime):
    _year(dateTime._year),
    _month(dateTime._month),
    _day(dateTime._day),
    _hour(dateTime._hour),
    _minute(dateTime._minute),
    _second(dateTime._second),
    _tz(dateTime._tz)
  {
  }

  DateTime::~DateTime()
  {
  }

  DateTime& DateTime::operator = (const DateTime& dateTime)
  {
    if (&dateTime != this)
    {
      _year        = dateTime._year;
      _month       = dateTime._month;
      _day         = dateTime._day;
      _hour        = dateTime._hour;
      _minute      = dateTime._minute;
      _second      = dateTime._second;
      _tz         = dateTime._tz;
    }
    return *this;
  }
  
  /*
  double DateTime::toSeconds() {
    return toSeconds(_year, _month, _day, _hour, _minute, _second); 
  }
  */

  // use this call, only if the DateTime object has a timezone
  // ie tzAvailable() == true
  void DateTime::makeUTC()
  {
    if(!tzAvailable()) {
      throw DateTimeException("timezone information not available for the conversion");
    }
    operator -= (_tz); 
    _tz = TimeZone(0,0);
  }

  // use this call, only if the DateTime object does not have a timezone
  // ie tzAvailable() == false
  void DateTime::makeUTC(TimeZone tz)
  {
    if(tzAvailable() && (_tz != tz) ) {
      ostringstream oss;
      oss << "DateTime object already has a timezone"
        << " which does not not match with supplied timezone";
      throw DateTimeException(oss.str());
    }
    operator -= (tz); 
    _tz = TimeZone(0,0);
  }

  // this call will fail, if the DateTime is already local ie tzAvailable()==true
  void DateTime::makeLocal(TimeZone tz)
  {
    if(!isUTC()) {
      ostringstream oss;
      oss << "DateTime object is already local ";
      throw DateTimeException(oss.str());
    }
    operator +=(tz); 
    _tz = tz;
  }

  int DateTime::dayOfYear() const
  {
    int doy = 0;
    for (int month = 1; month < _month; ++month)
      doy += maximumDayInMonthFor(_year, month);
    doy += _day;
    return doy;
  }
    
  DateTime& DateTime::operator += (const Duration& d)
  {
    int e_year=0, e_month=0, e_day=0;
    int e_hour=0, e_minute=0;
    double e_second=0;
    TimeZone e_zone;

    datetime_plus_duration(*this, d,
        e_year, e_month, e_day,
        e_hour, e_minute, e_second,
        e_zone);

    this->assign(e_year, e_month, e_day, e_hour, e_minute, e_second, e_zone);
    return *this;
  }
      
  DateTime& DateTime::operator -= (const Duration& d)
  {
    return operator +=(-d);
  }

  bool DateTime::operator == (const DateTime& dt) const
  {
    int result = DateAlgo::cmp(*this, dt);
    if(result == INDETERMINATE) {
      throw DateTimeException("INDETERMINATE DateTime == comparison");
    }
    return (result == 0);
  }

  bool DateTime::operator != (const DateTime& dt) const
  {
    return !operator==(dt);
  }


  bool DateTime::operator <  (const DateTime& dt) const
  {
    int result = DateAlgo::cmp(*this, dt);
    if(result == INDETERMINATE) {
      throw DateTimeException("INDETERMINATE DateTime < comparison");
    }
    return (result == -1);
  }

  bool DateTime::operator <= (const DateTime& dt) const
  {
    int result = DateAlgo::cmp(*this, dt);
    if(result == INDETERMINATE) {
      throw DateTimeException("INDETERMINATE DateTime <= comparison");
    }
    return ((result == -1) || (result == 0));
  }

  bool DateTime::operator >  (const DateTime& dt) const
  {
    int result = DateAlgo::cmp(*this, dt);
    if(result == INDETERMINATE) {
      throw DateTimeException("INDETERMINATE DateTime > comparison");
    }
    return (result == 1);
  }

  bool DateTime::operator >= (const DateTime& dt) const
  {
    int result = DateAlgo::cmp(*this, dt);
    if(result == INDETERMINATE) {
      throw DateTimeException("INDETERMINATE DateTime >= comparison");
    }
    return ((result == 1) || (result == 0));
  }

} // namespace XPlus
  
using namespace XPlus;

XPlus::DateTime operator + (const XPlus::DateTime& dt, const XPlus::Duration& d)
{
  int e_year=0, e_month=0, e_day=0;
  int e_hour=0, e_minute=0;
  double e_second=0;
  TimeZone e_zone;

  datetime_plus_duration(dt, d,
      e_year, e_month, e_day,
      e_hour, e_minute, e_second,
      e_zone);
  return XPlus::DateTime(e_year, e_month, e_day, e_hour, e_minute, e_second, e_zone);
}

XPlus::DateTime operator - (const XPlus::DateTime& dt, const XPlus::Duration& d)
{
  return operator + (dt, -d);
}


//FIXME revisit: do we expect both dt1, dt2 to have all fields specified ?
// if so, check and throw exception
XPlus::Duration operator - (const XPlus::DateTime& dt1, const XPlus::DateTime& dt2)
{
  //make sure both dt1 and dt2 have timezones
  if(!dt1.tzAvailable() || !dt2.tzAvailable()) {
    throw DateTimeException("INDETERMINATE DateTime operation - ");
  }
  
  //get rid of timezone part
  XPlus::DateTime dt1Utc = dt1;
  XPlus::DateTime dt2Utc = dt2;
  dt1Utc.makeUTC();
  dt2Utc.makeUTC();

  int days1 = dt1.dayOfYear();
  int days2 = dt2.dayOfYear();

  double temp=0, carry=0;
  int e_day=0, e_hour=0, e_minute=0;
  double e_second=0;


  // Seconds
  temp = dt1.second() - dt2.second();
  e_second = modulo(temp, 60);
  carry = fQuotient(temp, 60);

  // Minutes
  temp = dt1.minute() - dt2.minute() + carry;
  e_minute = modulo(temp, 60);
  carry = fQuotient(temp, 60);

  // Hours
  temp = dt1.hour() - dt2.hour() + carry;
  e_hour = modulo(temp, 24);
  carry = fQuotient(temp, 24);

  e_day = days1 - days2 + carry;

  return Duration(0, 0, e_day, e_hour, e_minute, e_second);
}

