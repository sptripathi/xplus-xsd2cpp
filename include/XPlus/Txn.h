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

#ifndef __UTILS_TXN_H__
#define __UTILS_TXN_H__

#include <string>
#include "XPlus/Exception.h"
#include "XPlus/StringUtils.h"

using namespace std;

namespace XPlus
{
  class Txn
  {
    protected:
      string                 _action;
      bool                   _outcome;
      string                 _successMsg;
      map<string, string>    _contextMap;
      XPlus::Exception       _exception;

    public:

    virtual ~Txn() {
    }
    
    void action(string s) {
       _action = s;
    }

    void failure(const Exception& ex) {
      _exception = ex;
      _outcome = false;
    }
    
    void failure() {
      _outcome = false;
    }
    
    void success(const string& msg) {
      _successMsg = msg;
      _outcome = true;
    }
    
    void success() {
      _outcome = true;
    }

    void addNameValueInfo(const string name, const string value) {
      _contextMap.insert(pair<string, string>(name, value));
    }

    void addNameValueInfo(const string name, const double value) {
      _contextMap.insert(pair<string, string>(name, toString<const double>(value)));
    }

    void outputToStream(ostream& os) 
    {
      char buffer[25];

      os << "{" << endl;

      snprintf(buffer, 25, "  %-25s ", "\"action\"" );
      os << buffer << ": \"" << _action << "\",";

      map<string, string>::const_iterator it = _contextMap.begin();
      for( ; it!= _contextMap.end(); ++it)
      {
        string name = string("\"") + it->first + "\"";
        snprintf(buffer, 25, "  %-25s ", name.c_str());
        os << endl;
        os << buffer << ": \"" << it->second << "\",";
      }

      os << endl;
      snprintf(buffer, 25, "  %-25s ", "\"outcome\"" );
      os << buffer << ": " << (_outcome ? "\"SUCCESS" : "\"FAILURE");
      if(_successMsg.length() > 0) os << _successMsg;
      os << "\"";

      DOMString emsg = _exception.msg();
      if(emsg.length() > 0)
      {
        os << "," << endl;
        snprintf(buffer, 25, "  %-25s ", "\"report\"" );
        os << buffer << ": " <<  emsg;
      }
      os << endl;
      os << "}" << endl; 
    }
  };
} 

#endif // __UTILS_TXN_H__
