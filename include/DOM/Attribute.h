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

#ifndef __ATTRIBUTE_H__
#define __ATTRIBUTE_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"

namespace DOM
{
  class Attribute : public Node
  {

  protected:
    const DOMStringPtr _name;
    const bool _specified;
    //DOMStringPtr  _value;

        // Introduced in DOM Level 2:
    ElementP  _ownerElement;

  public:

  Attribute( 
             DOMString* name,
             DOMString* value=NULL,
             DOMString* nsURI=NULL,
             DOMString* nsPrefix=NULL,
             Element* ownerElement=NULL,
             Document* ownerDocument=NULL,
             bool specified=true
             );
  virtual ~Attribute() {}

    virtual bool isSpecified() const {
      return _specified;
    }

    virtual const DOMString* getName() const {
      return _name;
    }

    virtual const DOMString* getValue() const {
      return getNodeValue();
    }

    virtual ElementP getOwnerElement() const {
      return _ownerElement;
    }
    virtual void setOwnerElement(ElementP ownerElement) {
      _ownerElement = ownerElement;
    }

  };
}

#endif
