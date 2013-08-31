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
        this->erase(it);
        return it->second;
      }
    }
    return NULL;
  }    
}
