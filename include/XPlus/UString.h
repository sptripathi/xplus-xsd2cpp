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

#ifndef __XPLUS_USTRING_H__
#define __XPLUS_USTRING_H__

#include <string>
#include <vector>
#include <sstream>

#include "XPlus/XPlusObject.h"
#include "XPlus/ConvertUTF.h"
#include "XPlus/TextEncoding.h"

using namespace std;

#if defined(XPLUS_UNICODE_WCHAR_T)
  // Unicode UTF-16 - use wchar_t
  typedef wchar_t      UChar;
  #define XML_LIT(lit) L##lit
#else
  // Characters are UTF-8 encoded
  typedef char        UChar;
#endif


typedef bool (*USTRING_CHAR_FN)(char ch);
namespace UTF8FNS {
  bool isWhiteSpaceChar(UChar ch);
  bool isSpaceChar(UChar ch);
  bool is_TAB_LF_CR(UChar ch);
  bool is_TAB_SPACE(UChar ch);
  bool isEqualChar(UChar ch);
}

// TODO: change the iterations on string using at() to rather use
// string iterators in .h and .cpp, for performance reasons

namespace XPlus
{

  /*  NB:
   *  It'll be a sin to use polymorphic behaviour with this class UString.
   *  the basic_string is not designed for derivations and doesnt have it's
   *  destructor declared virtual.
   */

#if defined(XPLUS_UNICODE_WCHAR_T)
  class UString: public std::wstring 
#else
  class UString: public std::string, public XPlusObject 
#endif
  {

    private:
    //  int _refCnt;

    public:
      UString():
      XPlusObject("UString")
      //  _refCnt(0)
    {
    }
      

#if defined(XPLUS_UNICODE_WCHAR_T)
  UString(const wstring wstr);
#endif

      UString(const char *buffer);
      UString(const char *buffer, unsigned int len);
      UString(const string buffer);

#if 0
      // AutoPtr requires:
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
#endif
      string str() const;
      void tokenize(UChar delim, vector<XPlus::UString>& tokens);
      unsigned int countCodePoints(TextEncoding::eTextEncoding enc=TextEncoding::UTF_8);

      void trimLeft(USTRING_CHAR_FN applicableToChar);
      void trimRight(USTRING_CHAR_FN applicableToChar);
      void trim(USTRING_CHAR_FN applicableToChar);
      bool matchCharSet(USTRING_CHAR_FN applicableToChar);
      void removeChars(USTRING_CHAR_FN shouldRemove);
      void replaceCharsWithChar(USTRING_CHAR_FN applicableToChar, UChar withChar);
      void removeContiguousChars(USTRING_CHAR_FN applicableToChar);
  
      static std::string UStringTostring(const UString& str);
      static UString stringToUString(const std::string& str);

	  friend istream& operator>>(istream &in, UString &out)
		{
			out = "";

			while (in.rdbuf()->in_avail() > 0)
			{
				out += static_cast<char>(in.rdbuf()->sbumpc());
			}

			return in;
		}

  };
}

#endif
