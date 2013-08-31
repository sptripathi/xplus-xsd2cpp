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

#include "XPlus/Duration.h"
#include "XPlus/DateTime.h"
#include "XPlus/DateAlgo.h"
#include "XPlus/Exception.h"

namespace XPlus
{
  void Duration::assign( int y, int m, int d, 
      int h, int min, double sec, bool neg)
  {
    _year = y;
    _month = m;
    _day = d;
    _hour = h;
    _minute = min;
    _second = sec;
    _sign = (neg?-1:1);
  }

  Duration& Duration::operator = (const Duration& dur)
  {
    if (&dur != this)
    {
      _year     = dur._year;
      _month    = dur._month;
      _day      = dur._day;
      _hour     = dur._hour;
      _minute   = dur._minute;
      _second   = dur._second;
      _sign     = dur._sign;
    }
    return *this;
  }

  bool Duration::operator != (const Duration& dur) const
  {
    int result = DateAlgo::cmp(*this, dur);
    if(result == DateTime::INDETERMINATE) {
      throw DateTimeException("INDETERMINATE Duration != comparison");
    }
    return (result == -1);
  }

  bool Duration::operator == (const Duration& dur) const
  {
    int result = DateAlgo::cmp(*this, dur);
    if(result == DateTime::INDETERMINATE) {
      throw DateTimeException("INDETERMINATE Duration == comparison");
    }
    return (result == 0);
  }


/*
  bool Duration::operator == (const Duration& d) const
  {
    return
      (
       (_year == d._year) &&
       (_month == d._month) &&
       (_day == d._day) &&
       (_hour == d._hour) &&
       (_minute == d._minute) &&
       (_second == d._second) &&
       (_sign == d._sign)
      );
  }
  */

  Duration Duration::operator - () const {
    Duration d2 = *this;
    d2.negate();
    return d2;
  }


  bool Duration::operator >  (const Duration& dur) const
  {
    int result = DateAlgo::cmp(*this, dur);
    if(result == DateTime::DateTime::INDETERMINATE) {
      throw DateTimeException("INDETERMINATE Duration > comparison");
    }
    return (result == 1);
  }

  bool Duration::operator >= (const Duration& dur) const
  {
    int result = DateAlgo::cmp(*this, dur);
    if(result == DateTime::INDETERMINATE) {
      throw DateTimeException("INDETERMINATE Duration >= comparison");
    }
    return ((result == 1) || (result == 0));
  }

  bool Duration::operator <  (const Duration& dur) const
  {
    return !operator>=(dur);
  }

  bool Duration::operator <= (const Duration& dur) const
  {
    return !operator>(dur);
  }
}

