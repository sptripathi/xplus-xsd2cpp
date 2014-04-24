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

#ifndef __XMLPLUSOBJECT_H__
#define __XMLPLUSOBJECT_H__

#include <iostream>
#include <sstream>

using namespace std;
//#define _SHAREDPTR_OBJ_DBG 1

/* beautify the compiler output... */
#define USED( var ) ((void)var)

namespace XPlus 
{

struct XPlusObject {
  string _objName;
  int _refCnt;
  bool _dontFree;


  inline void dontFree(bool b) {
    _dontFree = b;
  }
  inline bool dontFree() const {
    return _dontFree;
  }

  inline void printRefCnt() {
    cout << "@@@@@@@@@@ ptr= " << this  << " name:" <<  _objName << " cnt=" << _refCnt << " : printRefCnt" << endl;
  }

  inline virtual void duplicate() {
    ++_refCnt;
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "@@@@@@@@@@ ptr= " << this  << " name:" <<  _objName << " cnt=" << _refCnt << " : duplicate" << endl;
#endif
  }

  inline virtual void release() {
    --_refCnt;
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "   @@@@@@@@@@ ptr= " << this << " name:" <<  _objName << " cnt=" << _refCnt << " : release ";
    if(_refCnt==0) cout << ":     ***           DELETE ";
    cout << endl;
#endif
    if( (_refCnt==0) && !_dontFree) {
      //cout << "       @@@@ delete called..." << endl;
      delete this;
    }
  }

  XPlusObject(string name=""):
    _objName(name),
    _refCnt(0),
    _dontFree(false)
  {
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "@@@@@@@@@@ ptr= " << this  << " name:" <<  _objName << " cnt=" << _refCnt << " : XPlusObject::constr" << endl;
#endif
    ostringstream oss;
    oss << this;
  }

  virtual ~XPlusObject() {};
};

} // end namespace XPlus
#endif
