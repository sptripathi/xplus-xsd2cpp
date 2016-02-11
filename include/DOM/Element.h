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

#ifndef __ELEMENT_H__
#define __ELEMENT_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"

namespace DOM
{
  class Element : public Node 
  {
  protected:
    const DOMStringPtr        _tagName;

  public:

    Element(
        DOMString* tagName,
        DOMString* nsURI=NULL,
        DOMString* nsPrefix=NULL,
        Document* ownerDocument=NULL,
        Node* parentNode=NULL,
        Node* prevSibling=NULL,
        Node* nextSibling=NULL
        );

    virtual ~Element() {}
    
    virtual const DOMString* getTagName() const {
      return _tagName;
    }

    virtual const DOMString* getAttribute(DOMString* name);
    virtual void setAttribute(DOMString* name,
                              DOMString* value); // throws();
    virtual void removeAttribute(DOMString* name); // throws();
    virtual AttributeP getAttributeNode(DOMString* name);
    virtual AttributeP setAttributeNode(Attribute* newAttr); // throws();
    virtual AttributeP removeAttributeNode(AttributeP oldAttr); // throws();
    virtual NodeList* getElementsByTagName(DOMString* name);

        // Introduced in DOM Level 2:
    virtual const DOMString* getAttributeNS(DOMString* namespaceURI,
                                     DOMString* localName);
    virtual void setAttributeNS(DOMString* namespaceURI,
                                DOMString* qualifiedName,
                                DOMString* value); // throws();
    virtual void removeAttributeNS(DOMString* namespaceURI,
                                   DOMString* localName); // throws();
    virtual AttributeP getAttributeNodeNS(DOMString* namespaceURI,
                                            DOMString* localName);
    virtual AttributeP setAttributeNodeNS(AttributeP newAttr); // throws();
    virtual NodeList*  getElementsByTagNameNS(DOMString* namespaceURI,
                                              DOMString* localName);
    virtual bool hasAttribute(DOMString* name);
    virtual bool hasAttributeNS(DOMString* namespaceURI,
                                DOMString* localName);

    Element* copy(DOMString* tagName, Document* ownerDocument, Node* parentNode, Node* prevSibling, Node* nextSibling);
  };

}

#endif
