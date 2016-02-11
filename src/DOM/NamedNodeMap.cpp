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

#include <iostream>

#include "DOM/NamedNodeMap.h"
#include "DOM/Node.h"

using namespace std;

namespace DOM
{

  void NamedNodeMap::print() const
  {
    cout << "NamedNodeMap: "  << endl;
    std::map<DOMStringPtr, NodePtr>::const_iterator it = this->begin();
    for( ; it != this->end(); it++)
    {
      NodePtr pNode = it->second;
      if(pNode) 
      {
        cout << "name:" << pNode->getNodeName() << " value:" << pNode->getNodeValue() << endl;
      }
    }  
  }


  unsigned long NamedNodeMap::length() const {
    return this->size();
  }
  
  const Node* NamedNodeMap::item(unsigned long index) const
  {
    unsigned int idx = 0;
    std::map<DOMStringPtr, NodePtr>::const_iterator it = this->begin();
    for( ; it != this->end(); it++, idx++)
    {
      if(idx == index) {
        return const_cast<Node *>(it->second.get());
      }  
    }  
    return NULL;
  }

  Node* NamedNodeMap::item(unsigned long index)
  {
    unsigned int idx = 0;
    std::map<DOMStringPtr, NodePtr>::const_iterator it = this->begin();
    for( ; it != this->end(); it++, idx++)
    {
      if(idx == index) {
        return const_cast<Node *>(it->second.get());
      }  
    }  
    return NULL;
  }

  // returns NULL if node with matching name has a non-null namespace
  // TODO: verify this behaviour with spec
  Node* NamedNodeMap::getNamedItem(DOMString* name)
  {
    return getNamedItemNS(NULL, name);
  }

  Node* NamedNodeMap::setNamedItem(Node* pNode)
  {
    //TODO: do a find to check if already exists and throw
    // exception if it does else insert  
    //_namedNodeMap[pNode->getNodeName()] = pNode;
    this->insert(std::pair<DOMStringPtr, NodePtr>(pNode->getNodeName(), pNode));
    return pNode;
  }

  // no-op if it has a non-null namespace
  // TODO: verify this behaviour with spec
  Node* NamedNodeMap::removeNamedItem(DOMString* name) {
    removeNamedItemNS(NULL, name);
  }

  // Introduced in DOM Level 2:
  Node* NamedNodeMap::getNamedItemNS(DOMString* namespaceURI, DOMString* localName)
  {
    if(!localName) {
      return NULL;
    }
    std::map<DOMStringPtr, NodePtr>::iterator it = this->begin();
    for( ; it != this->end(); it++)
    {
      if( 
          ( *it->first == *localName) && 
          ( it->second.get() != NULL ) &&
          matchNamespace(it->second->getNamespaceURI(), namespaceURI)
        )
      {
        return it->second;
      }
    }
    return NULL; 
  }

  Node* NamedNodeMap::setNamedItemNS(Node* pNode) 
  {
    return setNamedItem(pNode);
  }

  Node* NamedNodeMap::removeNamedItemNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    if(!localName) {
      return NULL;
    }

    std::map<DOMStringPtr, NodePtr>::iterator it = this->begin();
    for( ; it != this->end(); it++)
    {
      if( 
          ( *it->first == *localName) && 
          ( it->second.get() != NULL ) &&
          matchNamespace(it->second->getNamespaceURI(), namespaceURI)
        )
      {
        NodePtr res = it->second;
        this->erase(it);
        return res;
      }
    }
    return NULL;
  }    
}
