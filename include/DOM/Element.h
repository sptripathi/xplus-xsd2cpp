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
    virtual DOMString* getAttributeNS(DOMString* namespaceURI,
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

  };

}

#endif
