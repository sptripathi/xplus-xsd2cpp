// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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
