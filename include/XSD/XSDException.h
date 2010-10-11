#ifndef __XSD_EXCEPTION_H__
#define __XSD_EXCEPTION_H__

#include "XPlus/Exception.h"

namespace XMLSchema
{
  class XSDException : public XPlus::Exception {
    public:
      XSDException(DOMString msg):
      XPlus::Exception(msg)
    { }
  };

  class LogicalError : public XSDException {
    public:
      LogicalError(DOMString msg):
      XSDException(msg)
    { }
  };

  class FSMException : public XSDException {
    public:
      FSMException(DOMString msg):
      XSDException(msg)
    { }
  };

  class ValidationException : public XSDException {
    public:
      ValidationException(DOMString msg):
      XSDException(msg)
    { }
  };

  class SchemaError : public XSDException {
    public:
      SchemaError(DOMString msg):
      XSDException(msg)
    { }
  };
} 
#endif // __XSD_EXCEPTION_H__
