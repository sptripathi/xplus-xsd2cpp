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

#include <string>
#include "DOM/CharacterData.h"
#include "DOM/Document.h"

//TODO: throw exceptions eg length, offset check, setting readonly 
// etc. Refer DOM spec.
using namespace std;

namespace DOM
{
  CharacterData::CharacterData(
      DOMString* nodeName,
      Node::NodeType nodeType, 
      DOMString* data,
      Document* ownerDocument,
      Node* parentNode,
      Node* prevSibling
      ):
    XPlusObject("CharacterData"),  
    Node(nodeName, nodeType, NULL, NULL, ownerDocument, data, parentNode, prevSibling)
  {
  }

  DOMString* CharacterData::substringData(unsigned long offset,
      unsigned long count)
  {
    if(!_nodeValue) {
      return NULL;
    }
    return new DOMString(_nodeValue->substr(offset, count));
  }

  void CharacterData::appendData(DOMString* arg)
  {
    if(!_nodeValue) {
      return;
    }
    _nodeValue->append(*arg);
  }

  void CharacterData::insertData(unsigned long offset, 
      DOMString* arg)
  {
    if(!_nodeValue) {
      return;
    }
    _nodeValue->insert(offset, *arg);
  }

  void CharacterData::deleteData(unsigned long offset, 
      unsigned long count)
  {
    if(!_nodeValue) {
      return;
    }
    _nodeValue->erase(offset, count);
  }

  void CharacterData::replaceData(unsigned long offset, 
      unsigned long count, 
      DOMString* arg)
  {
    if(!_nodeValue) {
      return;
    }
    _nodeValue->replace(offset, count, *arg);
  }


}
