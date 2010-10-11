// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Free Software Foundation, Inc.
// Author: Satya Prakash Tripathi
//
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
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

  Node* NamedNodeMap::getNamedItem(DOMString* name)
  {
    return NULL; //TODO  
  }

  Node* NamedNodeMap::setNamedItem(Node* pNode)
  {
    //TODO: do a find to check if already exists and throw
    // exception if it does else insert  
    //_namedNodeMap[pNode->getNodeName()] = pNode;
    this->insert(std::pair<DOMStringPtr, NodePtr>(pNode->getNodeName(), pNode));
    return pNode;
  }

  Node* NamedNodeMap::removeNamedItem(DOMString* name) {
    return NULL; //TODO  

  }

  // Introduced in DOM Level 2:
  Node* NamedNodeMap::getNamedItemNS(DOMString* namespaceURI, DOMString* localName)
  {
    return NULL; //TODO  
  }

  Node* NamedNodeMap::setNamedItemNS(Node* arg) 
  {
    return NULL; //TODO  
  }

  Node* NamedNodeMap::removeNamedItemNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return NULL; //TODO  

  }    
}
