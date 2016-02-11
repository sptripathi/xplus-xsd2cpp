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

#include <assert.h>
#include "XPlus/DateTime.h"
#include "XPlus/Date.h"
#include "XPlus/DateAlgo.h"
#include "XPlus/DateTimeUtils.h"

using namespace XPlus;

void testArithmetic()
{
  {
    DateTime dt1(1,1,1,0,0,0,DateTime::UTC_TZ);
    assert(DateTimeUtils::formatISO8601DateTime(dt1)== "0001-01-01T00:00:00Z") ;
  }

  {
    DateTime dt1(2009, 1, 29, 0, 0, 0 , TimeZone(3,0));
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-29T00:00:00+03:00");
  }
  
  {
    DateTime dt1(2009, 1, 29, 0, 0, 0 , TimeZone(3,15,true));
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-29T00:00:00-03:15");

    DateTime dt2 = DateTimeUtils::parseISO8601DateTime("2009-01-29T00:00:00-03:15");
    assert(dt2==dt1);
  }

  {
    DateTime dt1(2009, 1, 31, 1, 0, 0 , TimeZone(3,0));
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-31T01:00:00+03:00");
    dt1.makeUTC();
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-30T22:00:00Z");
    dt1.makeLocal(TimeZone(3,0));
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-31T01:00:00+03:00");
  }

  {
    DateTime dt1(2009, 1, 31, 23, 0, 0 );
    assert(DateTimeUtils::formatISO8601DateTime(dt1) == "2009-01-31T23:00:00");
    Duration   d(0   , 0,  0,  1, 0, 0  );
    DateTime dt2 = dt1 + d;
    assert(DateTimeUtils::formatISO8601DateTime(dt2) == "2009-02-01T00:00:00");
  }

  {
    // 2000-01-12T12:13:14Z	P1Y3M5DT7H10M3.3S	2001-04-17T19:23:17.3Z
    DateTime dt1(2000, 1, 12, 12, 13, 14, DateTime::UTC_TZ );
    Duration   d(1   , 3,  5,  7, 10, 3.3  );
    DateTime dt2 = dt1 + d;
    assert(DateTimeUtils::formatISO8601DateTime(dt2) == "2001-04-17T19:23:17.3Z");
  }
  
  {
    //2000-01-12	PT33H	2000-01-13
    Date dt1(2000, 1, 12);
    Duration   d( 0, 0, 0, 33);
    Date dt2 = dt1 + d;
    assert(DateTimeUtils::formatXsdDate(dt2) == "2000-01-13");
  }

  {
    // 2000-01	-P3M	1999-10
    YearMonth ym(2000, 1);
    Duration   d( 0, 3);
    ym -= d; 
    assert(DateTimeUtils::formatXsdYearMonth(ym) == "1999-10");
  }

  {
    // 2000-01	-P3M	1999-10
    YearMonth ym(2000, 1);
    Duration d2( 0, 3);
    YearMonth ym2 = ym - d2;
    assert(DateTimeUtils::formatXsdYearMonth(ym2) == "1999-10");
  }


  {
    Time t(11, 20, 30);
    assert(DateTimeUtils::formatXsdTime(t) == "11:20:30");
    Time t2 = DateTimeUtils::parseXsdTime("11:20:30");
    assert(DateTimeUtils::formatXsdTime(t2) == "11:20:30");
    assert(t==t2);
  }

}

void testRelational()
{
  {
    //2000-01-15T00:00:00 < 2000-02-15T00:00:00
    DateTime dt1(2000,1,15,0,0,0);
    DateTime dt2(2000,2,15,0,0,0);
    assert( (dt1 < dt2) == true);
  }

  {
    //2000-01-15T12:00:00 < 2000-01-16T12:00:00Z
    DateTime dt1(2000,1,15,12,0,0);
    DateTime dt2(2000,1,16,12,0,0, DateTime::UTC_TZ);
    assert( (dt1 < dt2) == true);
  }

  {
    //2000-01-01T12:00:00 <> 1999-12-31T23:00:00Z
    DateTime dt1(2000,1,1,12,0,0);
    DateTime dt2(1999,12,31,23,0,0, DateTime::UTC_TZ);
    assert( DateAlgo::cmp(dt1, dt2) == DateTime::INDETERMINATE);
  }

  {
    //2000-01-16T12:00:00 <> 2000-01-16T12:00:00Z
    DateTime dt1(2000,1,16,12,0,0);
    DateTime dt2(2000,1,16,12,0,0, DateTime::UTC_TZ);
    assert( DateAlgo::cmp(dt1, dt2) == DateTime::INDETERMINATE);
  }

  {
    //2000-01-16T00:00:00 <> 2000-01-16T12:00:00Z
    DateTime dt1(2000,1,16,0,0,0);
    DateTime dt2(2000,1,16,12,0,0, DateTime::UTC_TZ);
    assert( DateAlgo::cmp(dt1, dt2) == DateTime::INDETERMINATE);
  }
}

main()
{
  //testArithmetic();
  //testRelational();
  //2010-01-01T23:00:00Z
  //2010-01-01T12:00:00Z
  DateTime dt1 = DateTimeUtils::parseISO8601DateTime("2010-01-01T23:00:00Z");
  DateTime dt2 = DateTimeUtils::parseISO8601DateTime("2010-01-01T12:00:00Z");

  cout << (dt1 > dt2) << endl;
}
