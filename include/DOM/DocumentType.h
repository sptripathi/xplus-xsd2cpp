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

#ifndef __DOCUMENTTYPE_H__
#define __DOCUMENTTYPE_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"
#include "DOM/NamedNodeMap.h"
#include "XPlus/XPlusObject.h"

namespace DOM
{
  class DocumentType : public DOM::Node 
  {
  protected:

    DOMStringPtr         _name;
    NamedNodeMap         _entities;
    NamedNodeMap         _notations;
        // Introduced in DOM Level 2:
    DOMStringPtr         _publicId;
    DOMStringPtr         _systemId;
    DOMStringPtr         _internalSubset;

  public:
    DocumentType(
        const DOMString* name,
        NamedNodeMap          entities,
        NamedNodeMap          notations,
        const DOMString*      publicId,
        const DOMString*      systemId,
        const DOMString*      internalSubset,
        const Document*       ownerDocument);

    virtual ~DocumentType();

    virtual const DOMString* getName() const;
    virtual const DOMString* getPublicId() const;
    virtual const DOMString* getSystemId() const;
    virtual const DOMString* getInternalSubset() const;
    
    virtual const NamedNodeMap& getEntities() const;
    virtual const NamedNodeMap& getNotations() const;
  };
}

#endif
