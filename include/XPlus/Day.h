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

#ifndef __XPLUS_DAY__
#define __XPLUS_DAY__

#include "XPlus/DateTime.h"

namespace XPlus
{
  class Day : public DateTime
  {
    public:

      Day(int day=DateTime::MIN_VALID_DAY):
        DateTime(DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, day, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

       Day(const DateTime& dt):
        DateTime(DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, dt.day(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}


      int day() const {
        return DateTime::day();
      }

      Day& operator += (const Duration& d) {
        return dynamic_cast<Day&>(DateTime::operator+=(d));
      }

      Day& operator -= (const Duration& d) {
        return dynamic_cast<Day&>(DateTime::operator-=(d));
      }

      Day& operator = (const Day& day) {
        return dynamic_cast<Day&>(DateTime::operator=(day));
      }

      bool operator == (const Day& day) const {
        return DateTime::operator==(day);
      }

      bool operator != (const Day& day) const {
        return DateTime::operator!=(day);
      }

      bool operator <  (const Day& day) const {
        return DateTime::operator<(day);
      }

      bool operator <= (const Day& day) const {
        return DateTime::operator<=(day);
      }

      bool operator >  (const Day& day) const {
        return DateTime::operator>(day);
      }

      bool operator >= (const Day& day) const {
        return DateTime::operator>=(day);
      }

  };
}

#endif
