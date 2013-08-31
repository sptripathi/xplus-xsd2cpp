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
