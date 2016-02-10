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
