#ifndef __PI_H__
#define __PI_H__

#include "DOM/DOMCommonInc.h"

// The ProcessingInstruction interface represents a "processing instruction", used
// in XML as a way to keep processor-specific information in the text of the document.

namespace DOM
{
  class PI : public Node 
  {
  protected:
    const DOMStringPtr  _target;
    DOMStringPtr        _data;

  public:
    
    PI(DOMString* target, 
      DOMString* data,
      Document* ownerDocument=NULL):
    Node(target, Node::PROCESSING_INSTRUCTION_NODE, NULL, NULL, ownerDocument, NULL, ownerDocument),
    _target(target),
    _data(data)
    {
    }

    virtual ~PI() {}

    const DOMString* getTarget() const {
      return _target;
    }

    DOMString* getData() {
      return _data;
    }
    
  };
}

#endif
