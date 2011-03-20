// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#ifndef __DOCUMENTTYPE_H__
#define __DOCUMENTTYPE_H__

#include "DOM/DOMCommonInc.h"
#include "XPlus/XPlusObject.h"

namespace DOM
{
  class DocumentType : public XPlus::XPlusObject 
  {
  protected:

    const DOMStringPtr         _name;
    const NamedNodeMap&     _entities;
    const NamedNodeMap&     _notations;
        // Introduced in DOM Level 2:
    const DOMStringPtr         _publicId;
    const DOMStringPtr         _systemId;
    const DOMStringPtr         _internalSubset;

  public:
    virtual ~DocumentType(){}

    virtual const DOMString* getName();
    virtual const NamedNodeMap& getEntities();
    virtual const NamedNodeMap& getNotations();

    virtual const DOMString* getPublicId();
    virtual const DOMString* getSystemId();
    virtual const DOMString* getInternalSubset();
  };
}

#endif
