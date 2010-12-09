#ifndef __XPLUS_NAMESPACES_H__ 
#define __XPLUS_NAMESPACES_H__

#include "DOM/DOMCommonInc.h"

using namespace DOM;

namespace XPlus
{
  class Namespaces
  {
    public:
      // the string "xsi" and not this prefix's nsUri in the context
      static DOMString   s_xsiStr; 
      // pointer to DOMString : "http://www.w3.org/2001/XMLSchema-instance"
      static DOMString   s_xsiUri;
      // the string "type" and not this attribute's value in the context
      static DOMString   s_xsiTypeStr; 
      // the string "nil" and not this attribute's value in the context
      static DOMString   s_xsiNilStr;
      // the string "schemaLocation" and not this attribute's value in the context
      static DOMString   s_xsiSchemaLocationStr;
      // the string "noNamespaceSchemaLocation" and not this attribute's value in the context
      static DOMString   s_xsiNoNamespaceSchemaLocationStr;

      // respective static pointers to the above xsi strings
      static DOMStringPtr   s_xsiStrPtr; 
      static DOMStringPtr   s_xsiUriPtr;
      static DOMStringPtr   s_xsiTypeStrPtr; 
      static DOMStringPtr   s_xsiNilStrPtr;
      static DOMStringPtr   s_xsiSchemaLocationStrPtr;
      static DOMStringPtr   s_xsiNoNamespaceSchemaLocationStrPtr;
  };
}

#endif
