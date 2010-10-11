#ifndef __DOM_EXCEPTION_H__
#define __DOM_EXCEPTION_H__

#include "XPlus/Exception.h"

namespace DOM
{
  class DOMException : public XPlus::Exception {
    public:
      DOMException(DOMString msg):
      Exception(msg)
    {
    }
  };
  class XmlParseException : public XPlus::Exception {
    public:
      XmlParseException(DOMString msg):
      Exception(msg)
    {
    }
  };
  
  class XPathParseException : public XPlus::Exception {
    public:
      XPathParseException(DOMString msg):
      Exception(msg)
    {
    }
  };
  
} 
#endif // __DOM_EXCEPTION_H__
