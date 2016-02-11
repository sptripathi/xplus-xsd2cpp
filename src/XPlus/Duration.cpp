// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

