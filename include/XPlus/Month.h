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
};

#endif
