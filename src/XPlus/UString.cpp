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
    //_refCnt(0)
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
    //_refCnt(0)
  {
  }

  UString::UString(const char *buffer):
    XPlusObject("UString")
    //_refCnt(0)
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
    //_refCnt(0)
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
    //_refCnt(0)
  {
  }

  UString::UString(const char *buffer):
    XPlusObject("UString"),
    string(buffer)
    //_refCnt(0)
  {
  }

  UString::UString(const char *buffer, unsigned int len):
    XPlusObject("UString"),
    string(buffer, len)
    //_refCnt(0)
  {
  }
  
  string UString::str() const 
  {
    ostringstream oss;
    unsigned int len = this->length();
    for(unsigned int i=0; i<len; i++) {
      oss << this->at(i); 
    }
    return oss.str();
  }

#endif

  // FIXME: this method has limitations on tokenization
  // UTF-8: the UChar would be one byte, which  means only
  //        single-char delimiters allowed
  void UString::tokenize(UChar delim, vector<XPlus::UString>& tokens)
  {
    unsigned int offset=0, count=0, len= this->length();
    for(unsigned int i=0; i<len; i++)
    {
      // 0 1 2| 3 4| 5 6 7
      if(this->at(i) == delim) 
      {
        count = i - offset;
        XPlus::UString token = this->substr(offset, count); 
        tokens.push_back(token);
        offset = i+1; 
      }
    }

    if(offset < len) 
    {
      count = len - offset;
      XPlus::UString token = this->substr(offset, count); 
      tokens.push_back(token);
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
    for(size_type i=0; i<this->length(); i++)
    {
      if(!applicableToChar(this->at(i)) ) {
        return false;
      }
    }
    return true;
  }

  void UString::trimLeft(USTRING_CHAR_FN applicableToChar) 
  {
    size_type pos= 0;
    while( (pos < this->length()) && applicableToChar(this->at(pos)) ) {
      pos++;
    }
    this->erase(this->begin(), this->begin()+pos);
  }

  void UString::trimRight(USTRING_CHAR_FN applicableToChar) 
  {
    size_type len = this->length();
    if(len==0) {
      return;
    }
    int pos= len-1;
    while( (pos >= 0) && applicableToChar(this->at(pos)) ) {
      pos--;
    }
    if(pos < len-1) {
      this->erase(pos+1);
      //this->erase(pos+1, len-pos+1);
    }
  }

  void UString::trim(USTRING_CHAR_FN applicableToChar) 
  {
    this->trimLeft(applicableToChar);
    this->trimRight(applicableToChar);
  }
  
  void UString::removeChars(USTRING_CHAR_FN applicableToChar) 
  {
    for(size_type i=0; i<this->length(); i++)
    {
      if( applicableToChar(this->at(i)) ) {
        this->erase(this->begin()+i);
        i--;
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
    for(size_type i=0; i<this->length(); i++)
    {
      if( applicableToChar(this->at(i)) ) {
        this->erase(this->begin()+i);
        this->insert(this->begin()+i, withChar);
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
