// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE VERSION 3 for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE VERSION 3
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
