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
