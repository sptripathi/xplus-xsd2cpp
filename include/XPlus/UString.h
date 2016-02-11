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

  };
}

#endif
