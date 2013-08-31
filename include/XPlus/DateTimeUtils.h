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
