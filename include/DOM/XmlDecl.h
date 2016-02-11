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

#ifndef __XML_DECL_H__
#define __XML_DECL_H__

#include "XPlus/TextEncoding.h"
#include "DOM/DOMCommonInc.h"

using namespace XPlus;

namespace DOM
{

  enum eStandalone
  {
    STANDALONE_UNKNOWN         = -2,
    STANDALONE_UNSPECIFIED,
    STANDALONE_NO, 
    STANDALONE_YES
  };

  enum eXmlVersion
  {
    XML_VERSION_UNKNOWN        = -2,
    XML_VERSION_UNSPECIFIED,
    XML_VERSION_1_0,
    XML_VERSION_1_1
  };


  struct XmlDecl
  {
    public:

      XmlDecl(eXmlVersion version=XML_VERSION_1_0, 
          TextEncoding::eTextEncoding enc= TextEncoding::UNSPECIFIED,
          eStandalone standalone = STANDALONE_UNSPECIFIED  
          );


      XmlDecl(const DOMString* version, 
          const DOMString* encStr, 
          long standalone =  STANDALONE_UNSPECIFIED);

      inline eXmlVersion version() const {
        return _version; 
      }
      string versionString() const {
        return enumToStringVersion(_version);
      }
      inline void version(eXmlVersion versionEnum) {
        _version = versionEnum;
      }


      inline eStandalone standalone() const {
        return _standalone; 
      }
      string standaloneString() const {
        return enumToStringStandalone(_standalone);
      }
      inline void standalone(eStandalone standaloneEnum) {
        _standalone = standaloneEnum;
      }


      inline TextEncoding::eTextEncoding encoding() const {
        return _encoding.toEnum(); 
      }
      inline string encodingString() const {
        return _encoding.toString(); 
      }
      inline void encoding(TextEncoding::eTextEncoding encEnum) {
        _encoding = TextEncoding(encEnum);
      }

      void print() const
      {
        cout  << "XmlDecl: "
          << " version:"  << versionString()
          << " encoding:" << _encoding.toString()
          << " standalone:" << standaloneString()
          << endl; 
      }

      /////////////// static members //////////////////
      static string enumToStringVersion(eXmlVersion version);
      static string enumToStringStandalone(eStandalone standalone);
      static eXmlVersion stringToEnumVersion(string version);
      static string v_1_0;
      static string v_1_1;
      static string yes;
      static string no;
      static string unspecified;
      static string unknown;

    private:

      eXmlVersion      _version;
      TextEncoding     _encoding;
      eStandalone      _standalone;
  };
}

#endif
