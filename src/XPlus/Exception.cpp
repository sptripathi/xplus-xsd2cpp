// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

#include "XPlus/Exception.h"
#include "XPlus/StringUtils.h"

namespace XPlus
{

  Exception::Exception(string msg):
    _msg(msg)
  {
  }

  Exception::~Exception() throw() { };


  void Exception::msg(string str) {
    _msg = str;
  }

  void Exception::appendMsg(string str) {
    _msg += str;
  }

  string Exception::rawMsg() const {
    return _msg;
  }

  void Exception::setContext(const string name, const string value) {
    _contextMap.insert(pair<string, string>(name, value));
  }

  void Exception::setContext(const string name, const double value) {
    _contextMap.insert(pair<string, string>(name, toString<const double>(value)));
  }

  std::map<std::string, std::string> Exception::getContext() {
    return _contextMap;
  }

  std::string Exception::getContext(const string name) {
    return _contextMap[name];
  }

  void Exception::appendException(const Exception& ex)
  {
    this->appendMsg(ex.rawMsg());
    map<string, string>::const_iterator it = ex._contextMap.begin();
    for(; it != ex._contextMap.end(); ++it) {
      _contextMap.insert(*it);
    }
  }

  string Exception::msg() 
  {
    ostringstream oss;
    oss << _msg;
    map<string, string>::const_iterator it = _contextMap.begin();
    for( ; it!= _contextMap.end(); ++it) {
      oss << endl << "  " << it->first << ": " << it->second ;
    }
    return oss.str();
  }

} // end namespace XPlus
