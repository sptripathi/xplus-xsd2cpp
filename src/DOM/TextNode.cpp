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
