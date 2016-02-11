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

#ifndef _DateTimeUtils_INCLUDED
#define _DateTimeUtils_INCLUDED

#include "Poco/Foundation.h"

#include "XPlus/DateTime.h"
#include "XPlus/Date.h"
#include "XPlus/Day.h"
#include "XPlus/Month.h"
#include "XPlus/MonthDay.h"
#include "XPlus/YearMonth.h"
#include "XPlus/Time.h"
#include "XPlus/TimeZone.h"


namespace XPlus {

  class DateTimeUtils
  {
    public:

      //parse
      static void parse(const std::string& fmt, const std::string& str, DateTime& dateTime);
      static DateTime parse(const std::string& fmt, const std::string& str);
      static int parseMonth(std::string::const_iterator& it, const std::string::const_iterator& end);
      static int parseDayOfWeek(std::string::const_iterator& it, const std::string::const_iterator& end);
      static DateTime parseISO8601DateTime(const std::string& str);
      static Day parseXsdDay(const std::string& str);
      static Month parseXsdMonth(const std::string& str);
      static MonthDay parseXsdMonthDay(const std::string& str);
      static YearMonth parseXsdYearMonth(const std::string& str);
      static Date parseXsdDate(const std::string& str);
      static Time parseXsdTime(const std::string& str);
      static Duration parseXsdDuration(const std::string& str);

      //format
      static std::string format(const DateTime& dateTime, const std::string& fmt);
      static void append(std::string& str, const Duration& duration);
      static void append(std::string& str, const DateTime& dateTime, const std::string& fmt);
      static void appendTzdISO(std::string& str, DateTime dateTime);
      static std::string formatISO8601DateTime(const DateTime& dateTime);
      static std::string formatXsdDate(const Date& input);
      static std::string formatXsdDay(const Day& input);
      static std::string formatXsdMonth(const Month& input);
      static std::string formatXsdMonthDay(const MonthDay& input);
      static std::string formatXsdYearMonth(const YearMonth& input);
      static std::string formatXsdDuration(const Duration& input);
      static std::string formatXsdTime(const Time& input);


    protected:
      static TimeZone parseTZ(std::string::const_iterator& it, const std::string::const_iterator& end);
  };


} // namespace XPlus


#endif 
