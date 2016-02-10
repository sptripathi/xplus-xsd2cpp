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

#ifndef __NODE_FILTER_H__
#define __NODE_FILTER_H__

#include <list>
#include <vector>
#include "DOM/DOMAllInc.h"
#include "DOM/NodePredicates.h"


namespace DOM
{
  class NodePredicates
  {
    protected:
      DOMStringPtr   _nameToEquate;
      Node::NodeType _typeToEquate;
      //... add more

    public:
      NodePredicates();

      virtual ~NodePredicates() {}

    inline NodePredicates& nameToEquate(DOMString* nodeName) {
      _nameToEquate = nodeName;
      return *this;
    }
    
    inline const DOMString* nameToEquate() {
      return _nameToEquate;
    }
    
    inline NodePredicates& typeToEquate(const Node::NodeType nodeType) {
      _typeToEquate = nodeType;
      return *this;
    }
      
    inline const Node::NodeType typeToEquate() {
      return _typeToEquate;
    }

    bool evaluate(Node* nodePtr);
    bool evaluateNameEquality(Node* nodePtr);
    bool evaluateTypeEquality(Node* nodePtr);
  };
}
#endif
