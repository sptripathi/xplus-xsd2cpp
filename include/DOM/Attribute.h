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
