#ifndef __DOM_IMPLEMENTATION_H__
#define __DOM_IMPLEMENTATION_H__

#include "DOM/DOMCommonInc.h"
#include "XPlus/XPlusObject.h"

namespace DOM
{
  class DOMImplementation : public XPlus::XPlusObject 
  {
    public:
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
