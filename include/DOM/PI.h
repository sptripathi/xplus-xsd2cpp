// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
//
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the 
// "Software"), to deal in the Software without restriction, including 
// without limitation the rights to use, copy, modify, merge, publish, 
// distribute, sublicense, and/or sell copies of the Software, and to 
// permit persons to whom the Software is furnished to do so, subject to 
// the following conditions: 
// 
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software. 
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
//

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
    XPlusObject("PI"),  
    Node(target, Node::PROCESSING_INSTRUCTION_NODE, NULL, NULL, ownerDocument, NULL, ownerDocument),
    _target(target),
    _data(data)
    {
    }

    virtual ~PI() {}

    const DOMString* getTarget() const {
      return _target;
    }

    const DOMString* getData() const {
      return _data;
    }
    
  };
}

#endif
