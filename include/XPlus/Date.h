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

#ifndef __XPLUS_DATE__
#define __XPLUS_DATE__

#include "XPlus/DateTime.h"

namespace XPlus
{
  class Date : public DateTime
  {
    public:

      Date( int year=DateTime::MIN_VALID_YEAR, 
            int month=DateTime::MIN_VALID_MONTH, 
            int day=DateTime::MIN_VALID_DAY):
        DateTime(year, month, day, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}
      
      Date(const DateTime& dt):
        DateTime(dt.year(), dt.month(), dt.day(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
      { }


      int year() const {
        return DateTime::year();
      }

      int month() const {
        return DateTime::month();
      }

      int day() const {
        return DateTime::day();
      }

      Date& operator += (const Duration& d) {
        return dynamic_cast<Date&>(DateTime::operator+=(d));
      }

      Date& operator -= (const Duration& d) {
        return dynamic_cast<Date&>(DateTime::operator-=(d));
      }

      Date& operator = (const Date& date) {
        return dynamic_cast<Date&>(DateTime::operator=(date));
      }

      bool operator == (const Date& date) const {
        return DateTime::operator==(date);
      }

      bool operator != (const Date& date) const {
        return DateTime::operator!=(date);
      }

      bool operator <  (const Date& date) const {
        return DateTime::operator<(date);
      }

      bool operator <= (const Date& date) const {
        return DateTime::operator<=(date);
      }

      bool operator >  (const Date& date) const {
        return DateTime::operator>(date);
      }

      bool operator >= (const Date& date) const {
        return DateTime::operator>=(date);
      }
  };
}

#endif
