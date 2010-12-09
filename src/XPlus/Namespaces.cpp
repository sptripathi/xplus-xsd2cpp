#include "XPlus/Namespaces.h"

namespace XPlus
{
  DOMString     Namespaces::s_xsiStr                             = "xsi"; 
  DOMString     Namespaces::s_xsiUri                             = "http://www.w3.org/2001/XMLSchema-instance";
  DOMString     Namespaces::s_xsiTypeStr                         = "type"; 
  DOMString     Namespaces::s_xsiNilStr                          = "nil";
  DOMString     Namespaces::s_xsiSchemaLocationStr               = "schemaLocation";
  DOMString     Namespaces::s_xsiNoNamespaceSchemaLocationStr    = "noNamespaceSchemaLocation";

  DOMStringPtr  Namespaces::s_xsiStrPtr                          = new DOMString(s_xsiStr); 
  DOMStringPtr  Namespaces::s_xsiUriPtr                          = new DOMString(s_xsiUri);
  DOMStringPtr  Namespaces::s_xsiTypeStrPtr                      = new DOMString(s_xsiTypeStr); 
  DOMStringPtr  Namespaces::s_xsiNilStrPtr                       = new DOMString(s_xsiNilStr);
  DOMStringPtr  Namespaces::s_xsiSchemaLocationStrPtr            = new DOMString(s_xsiSchemaLocationStr);
  DOMStringPtr  Namespaces::s_xsiNoNamespaceSchemaLocationStrPtr = new DOMString(s_xsiNoNamespaceSchemaLocationStr);
}

