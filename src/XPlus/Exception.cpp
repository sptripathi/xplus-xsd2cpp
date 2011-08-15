// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2011   Satya Prakash Tripathi
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

extern "C" {
#include <stdio.h>
}

#include "XPlus/Exception.h"
#include "XPlus/StringUtils.h"


namespace XPlus
{

  Exception::Exception(DOMString msg):
    _msg(msg)
  {
  }

  Exception::~Exception() throw() { };


  void Exception::msg(DOMString str) {
    _msg = str;
  }

  void Exception::appendMsg(DOMString str) {
    _msg += str;
  }

  DOMString Exception::rawMsg() const {
    return _msg;
  }
  
  void Exception::setContext(const DOMString name, const vector<DOMString> values) {
    _contextMap.insert(pair<DOMString, vector<DOMString> >(name, values));
  }
  
  void Exception::setContext(const DOMString name, const DOMString value) {
    vector<DOMString> values;
    values.push_back(value);
    _contextMap.insert(pair<DOMString, vector<DOMString> >(name, values));
  }

  void Exception::setContext(const DOMString name, const double value) {
    vector<DOMString> values;
    values.push_back(toString<const double>(value));
    _contextMap.insert(pair<DOMString, vector<DOMString> >(name,values));
  }

  void Exception::appendException(const Exception& ex)
  {
    this->appendMsg(ex.rawMsg());
    map<DOMString, vector<DOMString> >::const_iterator it = ex._contextMap.begin();
    for(; it != ex._contextMap.end(); ++it) {
      _contextMap.insert(*it);
    }
  }

  DOMString Exception::msg() 
  {
    if( (_msg.length() == 0) && (_contextMap.size() == 0) ) {
      return "";
    }

    char buffer[25];

    ostringstream oss;
    oss << "  {" << endl;
    
    if(_msg.length() > 0)
    {
      snprintf(buffer, 25, "  %-25s ", "\"error\"");
      oss << "    " << buffer << " : \"" << _msg << "\",";
      oss << endl;
    }

    map<DOMString, vector<DOMString> >::const_iterator it = _contextMap.begin();
    bool notFirst = false;
    for( ; it!= _contextMap.end(); ++it)
    {
      if(notFirst) {
        oss << "," << endl;
      }
      notFirst = true;
      
      DOMString name = DOMString("\"") + it->first + "\"";
      snprintf(buffer, 25, "  %-25s ", name.c_str());

      oss << "    " << buffer << " : ";
      vector<DOMString> values = it->second;
      if(values.size() == 1) {
        oss <<  "\"" << values[0] << "\"";
      }
      else if(values.size() > 1)
      {
        oss << "[";
        for(unsigned int i=0; i<values.size(); i++)
        {
          oss <<  "\"" << values[i] << "\"";
          if(i != values.size()-1) {
            oss << ", ";
          }
        }
        oss << "]";
      }
    }

    oss << endl << "  }";
    return oss.str();
  }

} // end namespace XPlus
