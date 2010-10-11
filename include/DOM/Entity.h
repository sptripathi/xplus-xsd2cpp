#ifndef __ENTITY_H__
#define __ENTITY_H__

#include "DOM/DOMCommonInc.h"

namespace DOM
{
  class Entity : public XPlus::XPlusObject
  {
  protected:
    const DOMStringPtr _publicId;
    const DOMStringPtr _systemId;
    const DOMStringPtr _notationName;

  public:
    virtual ~Entity() {}

    virtual const DOMString* getPublicId() const;
    virtual const DOMString* getSystemId() const;
    virtual const DOMString* getNotationName() const;
  };
}

#endif
