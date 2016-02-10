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

#ifndef __DOM_IMPLEMENTATION_H__
#define __DOM_IMPLEMENTATION_H__

#include "DOM/DOMCommonInc.h"
#include "XPlus/XPlusObject.h"

namespace DOM
{
  class DOMImplementation : public XPlus::XPlusObject 
  {
    public:
      DOMImplementation():
      XPlusObject("DOMImplementation")
      {
      }

      virtual ~DOMImplementation() {}
      virtual bool hasFeature(DOMString* feature, DOMString* version);

      // Introduced in DOM Level 2:
      virtual DocumentType* createDocumentType(DOMString* qualifiedName,
          DOMString* publicId,
          DOMString* systemId);
      virtual Document* createDocument(DOMString* namespaceURI,
          DOMString* qualifiedName,
          DocumentType* doctype); // throws();
  };
}	

#endif
