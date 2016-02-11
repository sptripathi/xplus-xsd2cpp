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

    std::map<std::string, std::string> getContext();
    std::string getContext(const string name);
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
