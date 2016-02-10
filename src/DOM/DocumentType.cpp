// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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
