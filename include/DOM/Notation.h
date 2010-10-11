#ifndef __NOTATION_H__
#define __NOTATION_H__

#include "DOM/DOMCommonInc.h"

namespace DOM
{
  class Notation
  {
  protected:
    const DOMStringPtr _publicId;
    const DOMStringPtr _systemId;

  public:

    virtual ~Notation() {}
    const DOMString* getPublicId() const {
      return _publicId;
    }

    const DOMString* getSystemId() const {
      return _systemId;
    }
  };
}

#endif
