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

#ifndef __XPLUS_YEAR__
#define __XPLUS_YEAR__

#include "DateTime.h"

namespace XPlus
{
  class Year : public DateTime
  {
    public:

      Year(int year=DateTime::MIN_VALID_YEAR):
        DateTime(year, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      Year(const DateTime& dt):
        DateTime(dt.year(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      int year() const {
        return DateTime::year();
      }

      Year& operator += (const Duration& d) {
        return dynamic_cast<Year&>(DateTime::operator+=(d));
      }

      Year& operator -= (const Duration& d) {
        return dynamic_cast<Year&>(DateTime::operator-=(d));
      }

      Year& operator = (const DateTime& dateTime) {
        return dynamic_cast<Year&>(DateTime::operator=(dateTime));
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
