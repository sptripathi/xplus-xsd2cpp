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

#include <cmath>

#include "XPlus/DateAlgo.h"
#include "XPlus/TimeZone.h"
#include "XPlus/DateTime.h"
#include "XPlus/Duration.h"
#include "XPlus/FPA.h"

namespace XPlus 
{
  namespace DateAlgo
  {
    int fQuotient(double a, double b)
    {
      double q = a/b;
      int i = a/b;
      return ((q == i)? i : ceil(q)-1);
    }

    int fQuotient(double a, double low, double high)
    {
      return fQuotient(a - low, high - low);
    }

    double modulo(double a, double b) 
    {
      return (a - (fQuotient(a,b)*b));
    }

    double modulo(double a, double low, double high) 
    {
      return modulo(a - low, high - low) + low;
    }

    double toSeconds( int  year, int  month, int  day, int  hour, int  minute, double  second)
    {
      //long days = daysOfYearMonth(year, month) + day;
      //return days*DAY_TO_SECS + hour*HOUR_TO_SECS + minute*MIN_TO_SECS + second;
      return 0;
    }

    bool isLeapYear(int year)
    {
      return (modulo(year, 400) == 0 || (modulo(year, 100) != 0) && 
          modulo(year, 4) == 0);
    }

    int daysOfYear(int year)
    {
      int days = 0;
      for (int month = 1; month <= 12; ++month) {
        days += maximumDayInMonthFor(year, month);
      }
      return days;
    }

    int daysOfYearMonth(int year, int month)
    {
      int days = 0;
      for (int mon = 1; mon < month; ++mon) {
        days += maximumDayInMonthFor(year, mon);
      }
      return days;
    }

    int maximumDayInMonthFor(int yearValue, int monthValue) 
    {
      int month = modulo(monthValue, 1, 13);
      int year = yearValue + fQuotient(monthValue, 1, 13);

      static int daysOfMonthTable[] = 
      {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

      if (month == 2 && isLeapYear(year))
        return 29;
      else
        return daysOfMonthTable[month];
    }

    bool isValidDateTime(int year, int month, int day, int hour, int minute, double second, TimeZone tz)
    {
      if(year == DateTime::UNSPECIFIED)
        year = DateTime::MIN_VALID_YEAR;
      if(month == DateTime::UNSPECIFIED)
        month = DateTime::MIN_VALID_MONTH;
      if(day == DateTime::UNSPECIFIED)
        day = DateTime::MIN_VALID_DAY;
      if(hour == DateTime::UNSPECIFIED)
        hour = DateTime::MIN_VALID_HOUR;
      if(minute == DateTime::UNSPECIFIED)
        minute = DateTime::MIN_VALID_MINUTE;
      if(second == DateTime::UNSPECIFIED)
        second = DateTime::MIN_VALID_SECOND;

      if((hour == 24) && ((minute != 0) || (second!=0))) {
        return false;
      }

      return
        ( year >= DateTime::MIN_VALID_YEAR) &&
        ( (month >= DateTime::MIN_VALID_MONTH) && (month <= DateTime::MAX_VALID_MONTH) ) &&
        ( (day >= DateTime::MIN_VALID_DAY) && (day <= maximumDayInMonthFor(year, month)) ) &&
        ( (hour >= DateTime::MIN_VALID_HOUR) && (hour <= DateTime::MAX_VALID_HOUR) ) &&
        ( (minute >= DateTime::MIN_VALID_MINUTE) && (minute <= DateTime::MAX_VALID_MINUTE) ) &&
        //FIXME: verify FPA comp for "double" second
        ( (second >= DateTime::MIN_VALID_SECOND) && (second < DateTime::MAX_VALID_SECOND) ) &&
        ( ( (tz.hour() == DateTime::UNKNOWN_TZ.hour()) && (tz.minute() == DateTime::UNKNOWN_TZ.minute())) || 
          ( (ABS(tz.hour()) < DateTime::MAX_VALID_TZ_HOUR) && (ABS(tz.minute()) < DateTime::MAX_VALID_MINUTE))
        ); 
    }        
             
    void datetime_plus_duration(const DateTime& dt, const Duration& d, int& e_year, int& e_month, int& e_day, int& e_hour, int& e_minute, double& e_second, TimeZone& e_zone)
    {        
      //     
      // If a field in D is not specified, it is treated as if
      // it were zero. If a field in S is not specified, it is
      // treated in the calculation as if it were the minimum 
      // allowed value in that field, however, after the 
      // calculation is concluded, the corresponding field in 
      // E is removed (set to unspecified).
      //
      DateTime S = XPlus::DateTime(
          ((dt.year()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_YEAR : dt.year()),
          ((dt.month()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_MONTH : dt.month()),
          ((dt.day()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_DAY : dt.day()),
          ((dt.hour()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_HOUR : dt.hour()),
          ((dt.minute()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_MINUTE : dt.minute()),
          ((dt.second()==DateTime::UNSPECIFIED) ? DateTime::MIN_VALID_SECOND : dt.second()),
          ((dt.timeZone()==DateTime::UNKNOWN_TZ) ? TimeZone() : dt.timeZone())
          );
  
      Duration D = XPlus::Duration (
          ((d.year()==DateTime::UNSPECIFIED) ? 0 : d.year()),
          ((d.month()==DateTime::UNSPECIFIED) ? 0 : d.month()),
          ((d.day()==DateTime::UNSPECIFIED) ? 0 : d.day()),
          ((d.hour()==DateTime::UNSPECIFIED) ? 0 : d.hour()),
          ((d.minute()==DateTime::UNSPECIFIED) ?0  : d.minute()),
          ((d.second()==DateTime::UNSPECIFIED) ? 0 : d.second())
          );


      double temp=0, carry=0;

      // Months
      temp = S.month() + D.month();
      e_month = modulo(temp, 1, 13);
      carry = fQuotient(temp, 1, 13);

      // Years
      e_year =  S.year() + D.year() + carry ;

      //Zone
      e_zone = S.timeZone();

      // Seconds
      temp = S.second() + D.second();
      e_second = modulo(temp, 60);
      carry = fQuotient(temp, 60);

      // Minutes
      temp = S.minute() + D.minute() + carry;
      e_minute = modulo(temp, 60);
      carry = fQuotient(temp, 60);

      // Hours
      temp = S.hour() + D.hour() + carry;
      e_hour = modulo(temp, 24);
      carry = fQuotient(temp, 24);

      //Days
      int tempDays = 0;
      if( S.day() > maximumDayInMonthFor(e_year, e_month) ) {
        tempDays = maximumDayInMonthFor(e_year, e_month);
      }
      else if (S.day() < 1) {
        tempDays = 1;
      }
      else {
        tempDays = S.day();
      }
      e_day = tempDays + D.day() + carry;
      for(;;)
      {
        if(e_day < 1) {
          e_day = e_day + maximumDayInMonthFor(e_year, e_month - 1);
          carry = -1;
        }
        else if( e_day > maximumDayInMonthFor(e_year, e_month))
        {
          e_day = e_day - maximumDayInMonthFor(e_year, e_month);
          carry = 1;
        }
        else {
          break;
        }
        temp = e_month + carry;
        e_month = modulo(temp, 1, 13);
        e_year = e_year + fQuotient(temp, 1, 13);
      }

      if(dt.year() == DateTime::UNSPECIFIED) {
        e_year = DateTime::UNSPECIFIED;
      }
      if(dt.month() == DateTime::UNSPECIFIED) {
        e_month = DateTime::UNSPECIFIED;
      }
      if(dt.day() == DateTime::UNSPECIFIED) {
        e_day = DateTime::UNSPECIFIED;
      }
      if(dt.hour() == DateTime::UNSPECIFIED) {
        e_hour = DateTime::UNSPECIFIED;
      }
      if(dt.minute() == DateTime::UNSPECIFIED) {
        e_minute = DateTime::UNSPECIFIED;
      }
      if(dt.second() == DateTime::UNSPECIFIED) {
        e_second = DateTime::UNSPECIFIED;
      }
      if(dt.timeZone() == DateTime::UNKNOWN_TZ) {
        e_zone = DateTime::UNKNOWN_TZ;
      }
    }


    // return values:
    //  0              if P == Q 
    //  1              if P >  Q 
    // -1              if P <  Q 
    // INDETERMINATE   if P <> Q
    int cmp(const DateTime& dateTime1, const DateTime& dateTime2)
    {
      DateTime dt1 = dateTime1;
      DateTime dt2 = dateTime2;

      /*
         A. Normalize P and Q. That is, if there is a timezone present, but
         it is not Z, convert it to Z using the addition operation defined 
         in Adding durations to dateTimes (§E)
        Thus 2000-03-04T23:00:00+03:00 normalizes to 2000-03-04T20:00:00Z
       */
      if(dt1.tzAvailable()) {
        dt1.makeUTC();
      }
      if(dt2.tzAvailable()) {
        dt2.makeUTC();
      }

      double P[] = { dt1.year(), dt1.month(), dt1.day(), dt1.hour(), dt1.minute(), dt1.second() };
      double Q[] = { dt2.year(), dt2.month(), dt2.day(), dt2.hour(), dt2.minute(), dt2.second() };

      /*
         B. If P and Q either both have a time zone or both do not have a
         time zone, compare P and Q field by field from the year field 
         down to the second field, and return a result as soon as it can 
         be determined. That is:

         1. For each i in {year, month, day, hour, minute, second}
          If P[i] and Q[i] are both not specified, continue to the next i
          If P[i] is not specified and Q[i] is, or vice versa, stop and return P <> Q
          If P[i] < Q[i], stop and return P < Q
          If P[i] > Q[i], stop and return P > Q
         2. Stop and return P = Q
       */
      if( (dt1.tzAvailable() && dt2.tzAvailable())  ||
          (!dt1.tzAvailable() && !dt2.tzAvailable())
        )
      {
        for(unsigned char i=0; i<6; i++)
        {
          if( (P[i] == DateTime::UNSPECIFIED) && (Q[i] == DateTime::UNSPECIFIED) ) {
            continue;
          }
          else if( (P[i] != DateTime::UNSPECIFIED) || (Q[i] != DateTime::UNSPECIFIED) ) 
          {
            //FIXME: check if double would work with < and > operators
            if(P[i] < Q[i]) {
              return -1;
            }
            else if(P[i] > Q[i]) {
              return 1;
            }
          }
          else {
            return DateTime::INDETERMINATE;
          }
        }
        return 0; // P == Q
      }
      else 
      {
        /*
        C.Otherwise, if P contains a time zone and Q does not, compare as follows:

           P < Q if P < (Q with time zone +14:00)
           P > Q if P > (Q with time zone -14:00)
           P <> Q otherwise, that is, if (Q with time zone +14:00) < P < (Q with time zone -14:00)
        */
        if(dt1.tzAvailable())
        {
          DateTime dt2_low = dt2;
          dt2_low.makeUTC(TimeZone(14,0));
          bool less_than_low = (cmp(dt1, dt2_low) == -1)  ;
          if(less_than_low) {
            return -1;
          }
          
          DateTime dt2_high = dt2;
          dt2_high.makeUTC(TimeZone(-14,0));
          bool gt_than_high = (cmp(dt1, dt2_high) == 1)  ;
          if(gt_than_high) {
            return 1;
          }
          return DateTime::INDETERMINATE;  
        }
        // if(dt2.tzAvailable())
        else
        {
        /*
          D. Otherwise, if P does not contain a time zone and Q does, compare as follows:

           P < Q if (P with time zone -14:00) < Q.
           P > Q if (P with time zone +14:00) > Q.
           P <> Q otherwise, that is, if (P with time zone +14:00) < Q < (P with time zone -14:00)
       */
          int result = cmp(dt2, dt1);
          // dt2 > dt1
          if(result == 1) {
            return -1;
          }
          // dt2 < dt1
          else if(result == -1) {
            return 1;
          }
          else {
            return DateTime::INDETERMINATE;  
          }
        }
      }
    }


    // return values:
    //  0              if P == Q 
    //  1              if P >  Q 
    // -1              if P <  Q 
    // INDETERMINATE   if P <> Q
    int cmp(const Duration& dur1, const Duration& dur2)
    {
      double P[] = { dur1.year(), dur1.month(), dur1.day(), dur1.hour(), dur1.minute(), dur1.second() };
      double Q[] = { dur2.year(), dur2.month(), dur2.day(), dur2.hour(), dur2.minute(), dur2.second() };

      for(unsigned char i=0; i<6; i++)
      {
        if( (P[i] == DateTime::UNSPECIFIED) && (Q[i] == DateTime::UNSPECIFIED) ) {
          continue;
        }
        else if( (P[i] != DateTime::UNSPECIFIED) || (Q[i] != DateTime::UNSPECIFIED) ) 
        {
          //FIXME: check if double would work with < and > operators
          if(P[i] < Q[i]) { // P < Q
            return -1;
          }
          else if(P[i] > Q[i]) { // P > Q
            return 1;
          }
        }
        else {
          return DateTime::INDETERMINATE;
        }
      }
      return 0; // P == Q
    }


  } // end namespace DateAlgo
} // end namespace XPlus
