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
