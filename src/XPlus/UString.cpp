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


#include "XPlus/UString.h"

namespace UTF8FNS 
{
  // NB: currently handling only UTF-8 chars
  // #x9   : tab
  // #xA  : line feed
  // #xD  : carriage return
  // #x20 : space

  bool isWhiteSpaceChar(UChar ch) {
    return (ch == 0x20);
  }

  bool is_TAB_LF_CR(UChar ch) {
    return ( (ch == 0x09) || (ch == 0x0A) || (ch == 0x0D) );
  }
  
  bool is_TAB_SPACE(UChar ch) {
    return ( (ch == 0x09) || (ch == 0x20) );
  }
  
  bool isSpaceChar(UChar ch) {
    return ( (ch == 0x20) || (ch == 0x09) || (ch == 0x0A) || (ch == 0x0D) );
  }
  
  bool isEqualChar(UChar ch) {
    return (ch == '=');
  }
}

namespace XPlus
{

#if defined(XPLUS_UNICODE_WCHAR_T)
  UString::UString(std::string str):
    XPlusObject("UString")
  {
    this->reserve(str.size());
    for (std::string::const_iterator it = str.begin(); it != str.end();)
    {
      wchar_t c;
      int n = mbtowc(&c, &*it, MB_CUR_MAX);
      this->push_back(c);
      it += (n > 0 ? n : 1);
    }
  }

  UString::UString(const wstring wstr):
    XPlusObject("UString"),
    wstring(wstr)
  {
  }

  UString::UString(const char *buffer):
    XPlusObject("UString")
  {
    if(!buffer) {
      throw NullPointerException("UString constructed with NULL buffer");
    }
    for(unsigned int i=0; buffer[i] !=0; i++) 
    {
      wchar_t c;
      int n = mbtowc(&c, buffer+i, MB_CUR_MAX);
      this->push_back(c);
      i += (n > 0 ? n : 1);
    }
  }

  UString::UString(const char *buffer, unsigned int len)
    XPlusObject("UString")
  {
    if(!buffer) {
      throw NullPointerException("UString constructed with NULL buffer");
    }
    this->reserve(len);
    for(unsigned int i=0; i<len; i++) 
    {
      wchar_t c;
      int n = mbtowc(&c, buffer+i, MB_CUR_MAX);
      this->push_back(c);
      i += (n > 0 ? n : 1);
    }
  }

  string UString::str() const 
  {
    std::string result;
    result.reserve(this->size());
    for (UString::const_iterator it = this->begin(); it != this->end(); ++it)
    {
      char c;
      wctomb(&c, *it);
      result += c;
    }
    return result;
  }

#else

  UString::UString(const string str):
    XPlusObject("UString"),
    string(str)
  {
  }

  UString::UString(const char *buffer):
    XPlusObject("UString"),
    string(buffer)
  {
  }

  UString::UString(const char *buffer, unsigned int len):
    XPlusObject("UString"),
    string(buffer, len)
  {
  }
  
  string UString::str() const 
  {
    ostringstream oss;
    for (UString::const_iterator it = this->begin(); it != this->end(); ++it) {
      oss << *it;
    }
    return oss.str();
  }

#endif

  // FIXME: this method has limitations on tokenization
  // UTF-8: the UChar would be one byte, which  means only
  //        single-char delimiters allowed
  void UString::tokenize(UChar delim, vector<XPlus::UString>& tokens)
  {
    // 0 1 2| 3 4| 5 6 7
    UString::iterator begin = this->begin();
    UString::iterator itBegin = begin;
    UString::iterator end = this->end();

    UString token ="";
    for (UString::iterator it=begin; it!=end; ++it)
    {
      if(*it == delim)
      {
        token.assign(itBegin, it);
        itBegin = it+1;
        if(token.size() > 0) tokens.push_back(token);
      }
    }

    if(itBegin != end-1) {
      token.assign(itBegin,end);
      if(token.size() > 0) tokens.push_back(token);
    }
  }  

  unsigned int UString::countCodePoints(TextEncoding::eTextEncoding enc)
  {
    switch(enc)
    {
      case TextEncoding::UTF_8:
        return countCodePointsInUTF8String((UTF8 *)this->c_str(), this->length());
      default:
        return this->length();
    }
  }

  bool UString::matchCharSet(USTRING_CHAR_FN applicableToChar)
  {
    for(UString::iterator it=this->begin(); it!=this->end(); ++it)
    {
      if(!applicableToChar(*it) ) {
        return false;
      }
    }
    return true;
  }

  void UString::trimLeft(USTRING_CHAR_FN applicableToChar) 
  {
    string::iterator begin = this->begin();
    string::iterator end = this->end();
    string::iterator it=begin;
    for (it=begin; it!=end; ++it)
    {
      if(!applicableToChar(*it)) {
        break;
      }
    }
    this->erase(begin, it);
  }

  void UString::trimRight(USTRING_CHAR_FN applicableToChar) 
  {
    string::iterator begin = this->begin();
    string::iterator end = this->end() -1;
    string::iterator it=begin;
    for (it=end; it!=begin; --it)
    {
      if(!applicableToChar(*it)) {
        break;
      }
    }
    if(!applicableToChar(*it)) {
      ++it; 
    }
    this->erase(it, this->end());
  }

  void UString::trim(USTRING_CHAR_FN applicableToChar) 
  {
    this->trimLeft(applicableToChar);
    this->trimRight(applicableToChar);
  }
  
  void UString::removeChars(USTRING_CHAR_FN applicableToChar) 
  {
    for(UString::iterator it=this->begin(); it!=this->end(); ++it)
    {
      if( applicableToChar(*it) ) {
        this->erase(it);
        it--; 
      }
    }
  }

  void UString::removeContiguousChars(USTRING_CHAR_FN applicableToChar) 
  {
    if(this->length() == 0) {
      return;
    }
    // abcdeeeefg
    // 0123456789
    //        after remove-contiguous-char becomes:
    // abcdefg
    // 0123456
    for(size_type i=1; i<this->length(); i++)
    {
      if(this->at(i) != this->at(i-1)) {
        continue;
      }
      size_type ibegin = i-1;
      while(  (i<this->length()) &&
              (this->at(i) == this->at(i-1)) &&
              applicableToChar(this->at(i))
          )
      {
        i++;
      }

      if(i != ibegin) 
      {
        // in example above: 
        // i=8   ibegin=4   
        // numdup = i-ibegin =4 
        this->erase(ibegin, (i-ibegin-1));
        i = ibegin+1;
      }
    }
  }

  void UString::replaceCharsWithChar(USTRING_CHAR_FN applicableToChar, UChar withChar) 
  {
    for (UString::iterator it=this->begin(); it != this->end(); ++it)
    {
      if( applicableToChar(*it) ) {
        this->erase(it);
        --it; ++it;
        this->insert(it, withChar);
      }
    }
  }

  std::string UStringTostring(const UString& str)
  {
#if defined(XPLUS_UNICODE_WCHAR_T)
    std::string result;
    result.reserve(str.size());
    for (UString::const_iterator it = str.begin(); it != str.end(); ++it)
    {
      char c;
      wctomb(&c, *it);
      result += c;
    }
    return result;
#else
    return str;
#endif 
  }


  UString UString::stringToUString(const std::string& str)
  {
#if defined(XPLUS_UNICODE_WCHAR_T)
    UString result;
    result.reserve(str.size());
    for (std::string::const_iterator it = str.begin(); it != str.end();)
    {
      wchar_t c;
      int n = mbtowc(&c, &*it, MB_CUR_MAX);
      result += c;
      it += (n > 0 ? n : 1);
    }
    return result;
#else
    return str;
#endif 
  }



}
