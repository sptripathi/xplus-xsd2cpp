// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

 #include "DOM/XmlDecl.h"

namespace DOM
{
  string XmlDecl::v_1_0 = "1.0";
  string XmlDecl::v_1_1 = "1.1";
  string XmlDecl::yes = "yes";
  string XmlDecl::no = "no";
  string XmlDecl::unspecified = "unspecified";
  string XmlDecl::unknown = "unknown";

  XmlDecl::XmlDecl(eXmlVersion version, TextEncoding::eTextEncoding enc, eStandalone standalone):
    _version(version),
    _encoding(TextEncoding(enc)),
    _standalone(standalone)
  {
  }

  XmlDecl::XmlDecl(const DOMString* version, const DOMString* encStr, long standalone)
  {
    if(version) {
      _version = stringToEnumVersion(*version);
    }
    else {
      _version = XML_VERSION_1_0;
    }

    if(encStr) {
      _encoding = TextEncoding(*encStr);
    }
    else {
      _encoding = TextEncoding(TextEncoding::UNSPECIFIED);
    }

    _standalone = static_cast<eStandalone>(standalone);
  }


  string XmlDecl::enumToStringVersion(eXmlVersion version)
  {
    switch(version)
    {
      case XML_VERSION_1_0:
        return v_1_0;

      case XML_VERSION_1_1:
        return v_1_1;

      case XML_VERSION_UNSPECIFIED:
        return unspecified;

      default:
        return unknown;
    }
  }


  string XmlDecl::enumToStringStandalone(eStandalone standalone)
  {
    switch(standalone)
    {
      case STANDALONE_YES:
        return yes;

      case STANDALONE_NO:
        return no;

      case STANDALONE_UNSPECIFIED:
        return unspecified;

      default:
        return unknown;
    }
  }

  eXmlVersion XmlDecl::stringToEnumVersion(string version)
  {
    if(version ==  v_1_0) {
      return XML_VERSION_1_0; 
    }
    else if(version == v_1_1) {
      return XML_VERSION_1_1;
    }
    else if(version == "") {
      return XML_VERSION_UNSPECIFIED;
    }
    else {
      return XML_VERSION_UNKNOWN;
    }
  }


}
