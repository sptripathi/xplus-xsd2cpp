#ifndef __DOCUMENTTYPE_H__
#define __DOCUMENTTYPE_H__

#include "DOM/DOMCommonInc.h"
#include "XPlus/XPlusObject.h"

namespace DOM
{
  class DocumentType : public XPlus::XPlusObject 
  {
  protected:

    const DOMStringPtr         _name;
    const NamedNodeMap&     _entities;
    const NamedNodeMap&     _notations;
        // Introduced in DOM Level 2:
    const DOMStringPtr         _publicId;
    const DOMStringPtr         _systemId;
    const DOMStringPtr         _internalSubset;

  public:
    virtual ~DocumentType(){}

    virtual const DOMString* getName();
    virtual const NamedNodeMap& getEntities();
    virtual const NamedNodeMap& getNotations();

    virtual const DOMString* getPublicId();
    virtual const DOMString* getSystemId();
    virtual const DOMString* getInternalSubset();
  };
}

#endif
