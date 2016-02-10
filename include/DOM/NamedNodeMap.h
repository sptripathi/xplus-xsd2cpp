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

#ifndef __NAMED_NODE_MAP_H__
#define __NAMED_NODE_MAP_H__

#include <map>

#include "DOM/DOMCommonInc.h"

namespace DOM
{

  // maps name-ptr to node-ptr
  // eg. in case of attributes, maps attribute's localName to Attribute NodePtr
  class NamedNodeMap : public std::map<DOMStringPtr, NodePtr>
  {
    protected:

    public:
      virtual ~NamedNodeMap() {}

      unsigned long length() const;
      virtual Node* item(unsigned long index);
      virtual const Node* item(unsigned long index) const;
      virtual Node* getNamedItem(DOMString* name);
      virtual Node* setNamedItem(Node* arg); // throws();
      virtual Node* removeNamedItem(DOMString* name); // throws();

      // Introduced in DOM Level 2:
      virtual Node* getNamedItemNS(DOMString* namespaceURI, DOMString* localName);
      virtual Node* setNamedItemNS(Node* arg); // throws();
      virtual Node* removeNamedItemNS(DOMString* namespaceURI,
          DOMString* localName); // throws();

      //impl apis
      void print() const;
  };
}

#endif
