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

#ifndef __XPLUS_TIME__
#define __XPLUS_TIME__

#include "XPlus/DateTime.h"

namespace XPlus
{
  class Time : public DateTime
  {
    public:

      Time( int hour=0,
            int minute=0,
            int second=0):
        DateTime(DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, hour, minute, second)
    {}
      
      Time(const DateTime& dt):
        DateTime(DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, DateTime::UNSPECIFIED, dt.hour(), dt.minute(), dt.second())
      { }


      int hour() const {
        return DateTime::hour();
      }

      int minute() const {
        return DateTime::minute();
      }

      int second() const {
        return DateTime::second();
      }

      Time& operator += (const Duration& d) {
        return dynamic_cast<Time&>(DateTime::operator+=(d));
      }

      Time& operator -= (const Duration& d) {
        return dynamic_cast<Time&>(DateTime::operator-=(d));
      }

      Time& operator = (const Time& time) {
        return dynamic_cast<Time&>(DateTime::operator=(time));
      }

      bool operator == (const Time& time) const {
        return DateTime::operator==(time);
      }

      bool operator != (const Time& time) const {
        return DateTime::operator!=(time);
      }

      bool operator <  (const Time& time) const {
        return DateTime::operator<(time);
      }

      bool operator <= (const Time& time) const {
        return DateTime::operator<=(time);
      }

      bool operator >  (const Time& time) const {
        return DateTime::operator>(time);
      }

      bool operator >= (const Time& time) const {
        return DateTime::operator>=(time);
      }
  };
}

#endif
