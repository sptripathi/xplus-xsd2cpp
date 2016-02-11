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

#ifndef __DATE_ALGO_H__
#define __DATE_ALGO_H__

#include  <float.h>

#define DOUBLE_EQ(x,v) (((v - DBL_EPSILON) < x) && (x <( v + DBL_EPSILON)))

namespace XPlus 
{
  class TimeZone;
  class DateTime;
  class Duration;

  namespace DateAlgo
  {
    bool isValidDateTime(int year, int month, int day, int hour, int minute, double second, TimeZone tz);
    double toSeconds( int  year, int  month, int  day, int  hour, int  minute, double  second);
    int daysOfYearMonth(int year, int month);
    int daysOfYear(int year);

    int fQuotient(double a, double b);
    int fQuotient(double a, double low, double high);
    double modulo(double a, double b);
    double modulo(double a, double low, double high);
    bool isLeapYear(int year);
    int maximumDayInMonthFor(int yearValue, int monthValue);
    void datetime_plus_duration(const DateTime& dt, const Duration& d, int& e_year, int& e_month, int& e_day, int& e_hour, int& e_minute, double& e_second, TimeZone& e_zone);
    int cmp(const DateTime& dt1, const DateTime& dt2);
    int cmp(const Duration& dur1, const Duration& dur2);

  } // end namespace DateAlgo
} // end namespace XPlus

#endif
