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
