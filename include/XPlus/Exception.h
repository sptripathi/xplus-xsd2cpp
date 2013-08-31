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

#ifndef __UTILS_EXCEPTION_H__
#define __UTILS_EXCEPTION_H__

#include <stdexcept>
#include <string>
#include <map>

using namespace std;

namespace XPlus
{
  class Exception : public std::exception
  {
    protected:
      string                 _msg;
      map<string, string>    _contextMap;

    public:
     Exception(string msg="");

    virtual ~Exception() throw();
    
    virtual string msg();
    
    void msg(string str);
    
    void appendException(const Exception& ex);
    
    void appendMsg(string str);
    
    string rawMsg() const;

    void setContext(const string name, const double value);
    void setContext(const string name, const string value);
  };

  class NullPointerException : public XPlus::Exception {
    public:
      NullPointerException(string msg=""):
      Exception(msg)
    {
    }
  };

  class IndexOutOfBoundsException : public XPlus::Exception {
    public:
      IndexOutOfBoundsException(string msg=""):
      Exception(msg)
    {
    }
  };

  class RegularExpressionException: public XPlus::Exception
  {
    public:
      RegularExpressionException(string msg=""):
        Exception(msg)
      {
      }
  };
  
  class NotFoundException : public XPlus::Exception {
    public:
      NotFoundException(string msg=""):
      Exception(msg)
    {
    }
  };
  
  class DateTimeException : public XPlus::Exception {
    public:
      DateTimeException(string msg=""):
      Exception(msg)
    {
    }
  };
  
  class RuntimeException : public XPlus::Exception {
    public:
      RuntimeException(string msg=""):
      Exception(msg)
    {
    }
  };

  class StringException : public XPlus::Exception {
    public:
      StringException(string msg=""):
      Exception(msg)
    {
    }
  };

} 

#endif // __UTILS_EXCEPTION_H__
