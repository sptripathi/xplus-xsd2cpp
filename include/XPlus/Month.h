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

#ifndef __XPLUS_MONTH__
#define __XPLUS_MONTH__

#include "DateTime.h"

namespace XPlus
{
  class Month : public DateTime
  {
    public:

      Month(int month=DateTime::MIN_VALID_MONTH):
        DateTime(DateTime::UNSPECIFIED, month, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      Month(const DateTime& dt):
        DateTime(DateTime::UNSPECIFIED, dt.month(), DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED)
    {}

      int month() const {
        return DateTime::month();
      }

      Month& operator += (const Duration& d) {
        return dynamic_cast<Month&>(DateTime::operator+=(d));
      }

      Month& operator -= (const Duration& d) {
        return dynamic_cast<Month&>(DateTime::operator-=(d));
      }

      Month& operator = (const DateTime& dateTime) {
        return dynamic_cast<Month&>(DateTime::operator=(dateTime));
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
