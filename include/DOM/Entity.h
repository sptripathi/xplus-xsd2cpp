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

#ifndef __ENTITY_H__
#define __ENTITY_H__

#include "DOM/DOMCommonInc.h"

namespace DOM
{
  class Entity : public XPlus::XPlusObject
  {
  protected:
    const DOMStringPtr _publicId;
    const DOMStringPtr _systemId;
    const DOMStringPtr _notationName;

  public:
    Entity():
      XPlusObject("Entity")
    {
    }
    virtual ~Entity() {}

    virtual const DOMString* getPublicId() const;
    virtual const DOMString* getSystemId() const;
    virtual const DOMString* getNotationName() const;
  };
}

#endif
