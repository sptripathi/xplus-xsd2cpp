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
