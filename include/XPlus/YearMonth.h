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

#ifndef __XPLUS_YEARMONTH__
#define __XPLUS_YEARMONTH__

#include "DateTime.h"

namespace XPlus
{
  class YearMonth : public DateTime
  {
    public:

      YearMonth(int year=DateTime::MIN_VALID_YEAR, int month=DateTime::MIN_VALID_MONTH):
        DateTime(year, month, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}
      
      YearMonth(const DateTime& dt):
        DateTime(dt.year(), dt.month(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
      { }

      inline int year() const {
        return DateTime::year();
      }

      inline int month() const {
        return DateTime::month();
      }

      YearMonth& operator += (const Duration& d) {
        return dynamic_cast<YearMonth&>(DateTime::operator+=(d));
      }

      YearMonth& operator -= (const Duration& d) {
        return dynamic_cast<YearMonth&>(DateTime::operator-=(d));
      }

      YearMonth& operator = (const DateTime& dateTime) {
        return dynamic_cast<YearMonth&>(DateTime::operator=(dateTime));
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
