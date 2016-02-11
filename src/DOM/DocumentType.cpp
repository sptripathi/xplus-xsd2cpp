// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

#include "DOM/DocumentType.h"
#include "DOM/Document.h"

namespace DOM
{
  DocumentType::DocumentType(
        const DOMString* name,
        NamedNodeMap    entities,
        NamedNodeMap    notations,
        const DOMString*      publicId,
        const DOMString*      systemId,
        const DOMString*      internalSubset,
        const Document*       ownerDocument
    ):
    XPlusObject("DocumentType"),
    Node( const_cast<DOMString *>(name), 
          Node::DOCUMENT_TYPE_NODE, NULL, NULL, 
          const_cast<Document* >(ownerDocument), 
          NULL,
          dynamic_cast<Node *>(const_cast<Document* >(ownerDocument))
        ),
    _name(const_cast<DOMString *>(name)),
    _entities(entities),
    _notations(notations),
    _publicId(const_cast<DOMString *>(publicId)),
    _systemId(const_cast<DOMString *>(systemId)),
    _internalSubset(const_cast<DOMString *>(internalSubset))
  {
  }

  DocumentType::~DocumentType()
  {}

  const DOMString* DocumentType::getName() const {
    return _name;
  }

  const DOMString* DocumentType::getPublicId() const {
    return _publicId;
  }

  const DOMString* DocumentType::getSystemId() const {
    return _systemId;
  }

  const DOMString* DocumentType::getInternalSubset() const {
    return _internalSubset;
  }

  const NamedNodeMap& DocumentType::getEntities() const {
    return _entities;
  }
  
  const NamedNodeMap& DocumentType::getNotations() const {
    return _notations;
  }
}
