// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
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

#ifndef __XMLPLUSOBJECT_H__
#define __XMLPLUSOBJECT_H__

#include <iostream>

using namespace std;
//#define _SHAREDPTR_OBJ_DBG 1

namespace XPlus 
{

struct XPlusObject {
  int _refCnt;

  inline void printRefCnt() {
    cout << "@@@@@@@@@@ ptr= " << this << " cnt=" << _refCnt << " : printRefCnt" << endl;
  }

  inline virtual void duplicate() {
    ++_refCnt;
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "@@@@@@@@@@ ptr= " << this << " cnt=" << _refCnt << " : duplicate" << endl;
#endif
  }

  inline virtual void release() {
    --_refCnt;
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "@@@@@@@@@@ ptr= " << this << " cnt=" << _refCnt << " : release ";
    if(_refCnt==0) cout << ":     ***           DELETE ";
    cout << endl;
#endif
    if(_refCnt==0) {
      delete this;
    }
  }

  XPlusObject():
    _refCnt(0)
  {
#ifdef _SHAREDPTR_OBJ_DBG
    cout << "@@@@@@@@@@ ptr= " << this << " cnt=" << _refCnt << " : XPlusObject::constr" << endl;
#endif
  }

  virtual ~XPlusObject() {};
};

} // end namespace XPlus
#endif
