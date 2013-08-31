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

#include "DOM/Attribute.h"
#include "DOM/TextNode.h"
#include "DOM/Element.h"
#include "DOM/Document.h"

namespace DOM
{
  Attribute::Attribute(
                  DOMString* name,
                  DOMString* value,
                  DOMString* nsURI,
                  DOMString* nsPrefix,
                  Element* ownerElement,
                  Document* ownerDocument,
                  bool specified
                ):
    XPlusObject("Attribute"),            
    Node(name, Node::ATTRIBUTE_NODE, nsURI, nsPrefix, ownerDocument, value, NULL),
    _name(name),
    _specified(specified),
    _ownerElement(ownerElement)
    {
      if(_ownerElement) {
        _ownerElement->setAttributeNode(this);
      }
      if(value) {
        createChildTextNode(value);
      }
    }

  /*
  void Attribute::setValue(DOMString* value)
  {
    if(value) {
      new TextNode(value, this->getOwnerDocument(), this);
    }
  } 
  */
}
