// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

#include "DOM/TextNode.h"
#include "DOM/Document.h"

namespace DOM
{
  TextNode::TextNode(
      DOMString* nodeValue,
      Document* ownerDocument,
      Node* parentNode,
      Node* prevSibling
      ):
    XPlusObject("TextNode"),  
    CharacterData(new DOMString("#text"), Node::TEXT_NODE, nodeValue, ownerDocument, parentNode, prevSibling)
  {
  }

  /*
Breaks this node into two nodes at the specified offset, keeping both in the tree as siblings. After being split, this node will contain all the content up to the offset point. A new node of the same type, which contains all the content at and after the offset point, is returned. If the original node had a parent node, the new node is inserted as the next sibling of the original node. When the offset is equal to the length of this node, the new node has no data.
     */
  TextNodeP TextNode::splitText(unsigned long offset)
  {
    TextNodeP nextTextNode = new TextNode(*this);  
    this->deleteData(offset+1, this->getLength()-offset-1);
    nextTextNode->deleteData(0, offset+1);

    Node* parentNode = this->getParentNode();
    if(parentNode) 
    {
      parentNode->insertAfter(nextTextNode, this);    
    }
    else {
      // parent-less node:TODO log error/exception
    }

    return nextTextNode;
  }

}
