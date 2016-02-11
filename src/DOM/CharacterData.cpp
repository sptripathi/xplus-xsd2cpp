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
