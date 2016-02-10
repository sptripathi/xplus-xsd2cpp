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

#ifndef __XPLUS_DURATION__
#define __XPLUS_DURATION__

#include <iostream>
using namespace std;

namespace XPlus
{
  class DateTime;

  class Duration
  {
    public:

      Duration(
          int  year=0,
          int  month=0,
          int  day=0,
          int  hour=0,
          int  minute=0,
          double  second=0,
          bool neg=false
          ):
        _year(year),
        _month(month),
        _day(day),
        _hour(hour),
        _minute(minute),
        _second(second),
        _sign(neg?-1:1)
    { 
    }

      int year() const;
      int month() const;
      int day() const;
      int hour() const;
      int minute() const;
      double second() const;
      void negate() {
        _sign *= -1;
      }
      bool negative() const {
        return (_sign==-1);
      }

      void assign(int year, int month, int day, 
          int hour, int minute, double second, bool neg=false);

      Duration operator - () const;
      Duration& operator = (const Duration& dur);
      bool operator == (const Duration& dur) const;	
      bool operator != (const Duration& dur) const;	
      bool operator <  (const Duration& dur) const;	
      bool operator <= (const Duration& dur) const;	
      bool operator >  (const Duration& dur) const;	
      bool operator >= (const Duration& dur) const;
      
      void print();

    private:

      int  _year;
      int  _month;
      int  _day;
      int  _hour;
      int  _minute;
      double  _second;
      short _sign;
  };

  inline int Duration::year() const {
    return _sign*_year;
  }

  inline int Duration::month() const {
    return _sign*_month;
  }

  inline int Duration::day() const {
    return _sign*_day;
  }

  inline int Duration::hour() const {
    return _sign*_hour;
  }

  inline int Duration::minute() const {
    return _sign*_minute;
  }

  inline double Duration::second() const {
    return _sign*_second;
  }

  inline void Duration::print() {
    cout << " Duration: [ " 
      << "year=" << _year
      << " month=" << _month
      << " day=" << _day
      << " hour=" << _hour
      << " minute=" << _minute
      << " second=" << _second
      << " sign=" << _sign
      << " ]"
      << endl;
  }

      
}

#endif
