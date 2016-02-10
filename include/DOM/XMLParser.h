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

#ifndef __XMLPARSER_H__
#define __XMLPARSER_H__

#include <string>
#include "XPlus/XPlusObject.h"

using namespace std;

namespace DOM
{
  class XMLParser : public XPlus::XPlusObject
  {

    public:
      XMLParser():
      XPlusObject("XMLParser")
      {
      }
      virtual ~XMLParser() {}
      virtual void setUserData(void *userData) =0;
      virtual bool parseXmlFile(string filePath)=0;
  };

}

#endif
