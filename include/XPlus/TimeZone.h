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

#ifndef __XPLUS_TIMEZONE__
#define __XPLUS_TIMEZONE__

#include "XPlus/Duration.h"

namespace XPlus
{
  class TimeZone : public Duration 
  {
    private:

    public:

      TimeZone(int  hour=0, int minute=0, bool negative=false):
        Duration(0, 0 , 0, hour, minute, 0, negative)
    { }

      inline int hour() const {
        return Duration::hour();
      }

      inline int minute() const {
        return Duration::minute();
      }
  };
}

#endif

