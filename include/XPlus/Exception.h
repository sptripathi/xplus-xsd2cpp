// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2011 Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#ifndef __UTILS_EXCEPTION_H__
#define __UTILS_EXCEPTION_H__

#include <stdexcept>
#include <map>
#include <vector>
#include "XPlus/UString.h"

using namespace std;
using namespace DOM;

namespace XPlus
{
  class Exception : public std::exception
  {
    protected:
      DOMString                          _msg;
      map<DOMString, vector<DOMString> >     _contextMap;

    public:
     Exception(DOMString msg="");

    virtual ~Exception() throw();
    
    virtual DOMString msg();
    
    void msg(DOMString str);
    
    void appendException(const Exception& ex);
    
    void appendMsg(DOMString str);
    
    DOMString rawMsg() const;
  
    void outcome(DOMString str);
    DOMString outcome();

    inline map<DOMString, vector<DOMString> > getContext() {
      return _contextMap; 
    }
    
    void setContext(const DOMString name, const double value);
    void setContext(const DOMString name, const DOMString value);
    void setContext(const DOMString name, const vector<DOMString> values);
  };

  class NullPointerException : public XPlus::Exception {
    public:
      NullPointerException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

  class IndexOutOfBoundsException : public XPlus::Exception {
    public:
      IndexOutOfBoundsException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

  class RegularExpressionException: public XPlus::Exception
  {
    public:
      RegularExpressionException(DOMString msg=""):
        Exception(msg)
      {
      }
  };
  
  class NotFoundException : public XPlus::Exception {
    public:
      NotFoundException(DOMString msg=""):
      Exception(msg)
    {
    }
  };
  
  class IndeterminateException : public XPlus::Exception {
    public:
      IndeterminateException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

  class DateTimeException : public XPlus::Exception {
    public:
      DateTimeException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

  class RuntimeException : public XPlus::Exception {
    public:
      RuntimeException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

  class StringException : public XPlus::Exception {
    public:
      StringException(DOMString msg=""):
      Exception(msg)
    {
    }
  };

} 

#endif // __UTILS_EXCEPTION_H__
