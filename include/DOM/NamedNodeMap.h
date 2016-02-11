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
