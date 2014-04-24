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

#ifndef __XPLUS_MONTHDAY__
#define __XPLUS_MONTHDAY__

#include "DateTime.h"

namespace XPlus
{
  class MonthDay : public DateTime
  {
    public:

      MonthDay(int month=DateTime::MIN_VALID_MONTH, int day=DateTime::MIN_VALID_DAY):
        DateTime(DateTime::UNSPECIFIED, month, day, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      MonthDay(const DateTime& dt):
        DateTime(DateTime::UNSPECIFIED, dt.month(), dt.day(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      int month() {
        return DateTime::month();
      }

      int day() {
        return DateTime::day();
      }

      MonthDay& operator += (const Duration& d) {
        return dynamic_cast<MonthDay&>(DateTime::operator+=(d));
      }

      MonthDay& operator -= (const Duration& d) {
        return dynamic_cast<MonthDay&>(DateTime::operator-=(d));
      }

      MonthDay& operator = (const DateTime& dateTime) {
        return dynamic_cast<MonthDay&>(DateTime::operator=(dateTime));
      }

      bool operator == (const DateTime& dateTime) const {
        return DateTime::operator==(dateTime);
      }

      bool operator != (const DateTime& dateTime) const {
        return DateTime::operator!=(dateTime);
      }

      bool operator <  (const DateTime& dateTime) const {
        return DateTime::operator<(dateTime);
      }

      bool operator <= (const DateTime& dateTime) const {
        return DateTime::operator<=(dateTime);
      }

      bool operator >  (const DateTime& dateTime) const {
        return DateTime::operator>(dateTime);
      }

      bool operator >= (const DateTime& dateTime) const {
        return DateTime::operator>=(dateTime);
      }

  };
}

#endif

