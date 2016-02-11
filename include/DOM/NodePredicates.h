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
