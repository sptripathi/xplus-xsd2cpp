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

#ifndef __ATTRIBUTE_H__
#define __ATTRIBUTE_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"

namespace DOM
{
  class Attribute : public Node
  {

  protected:
    const DOMStringPtr _name;
    const bool _specified;
    //DOMStringPtr  _value;

        // Introduced in DOM Level 2:
    ElementP  _ownerElement;

  public:

  Attribute( 
             DOMString* name,
             DOMString* value=NULL,
             DOMString* nsURI=NULL,
             DOMString* nsPrefix=NULL,
             Element* ownerElement=NULL,
             Document* ownerDocument=NULL,
             bool specified=true
             );
  virtual ~Attribute() {}

    virtual bool isSpecified() const {
      return _specified;
    }

    virtual const DOMString* getName() const {
      return _name;
    }

    virtual const DOMString* getValue() const {
      return getNodeValue();
    }

    virtual ElementP getOwnerElement() const {
      return _ownerElement;
    }
    virtual void setOwnerElement(ElementP ownerElement) {
      _ownerElement = ownerElement;
    }

  };
}

#endif
