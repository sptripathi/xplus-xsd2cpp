// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
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

#include "DOM/Element.h"
#include "DOM/Attribute.h"
#include "DOM/NodePredicates.h"

namespace DOM
{
  Element::Element(
      DOMString* tagName,
      DOMString* nsURI,
      DOMString* nsPrefix,
      Document* ownerDocument,
      Node* parentNode,
      Node* prevSibling,
      Node* nextSibling
      ):
    Node(tagName, Node::ELEMENT_NODE, nsURI, nsPrefix, ownerDocument, NULL, parentNode, prevSibling, nextSibling),
    _tagName(tagName),
    _textBufferOnDocBuild("")
  {

  }

  NodeList* Element::getElementsByTagName(DOMString* name)
  {
    //TODO
    return NULL;
    /*
    NodePredicates elemByNamePred;
    elemByNamePred.nameToEquate(name).typeToEquate(Node::ELEMENT_NODE);
    vector<NodePtr>* nodeList = new vector<NodePtr>();
    _childNodes.getFilteredNodes(elemByNamePred, *nodeList);
    return nodeList;
    */
  }

  const DOMString* Element::getAttribute(DOMString* name) {
    Node* pAttr = _attributes.getNamedItem(name);
    if(pAttr) {
      return pAttr->getNodeValue();
    }
    return NULL;
  }

  void Element::setAttribute(DOMString* name,
      DOMString* value) {
    return; //TODO
  }

  void Element::removeAttribute(DOMString* name)
  {
    return; //TODO
  }

  AttributeP Element::getAttributeNode(DOMString* name)
  {
    return NULL; //TODO
  }

  AttributeP Element::setAttributeNode(Attribute* newAttr)
  {
    _attributes.setNamedItem(newAttr);
    return newAttr;
  }

  AttributeP Element::removeAttributeNode(AttributeP oldAttr)
  {
    return NULL; //TODO
  }


  // Introduced in DOM Level 2:
  DOMString* Element::getAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return NULL; //TODO
  }

  void Element::setAttributeNS(DOMString* namespaceURI,
      DOMString* qualifiedName,
      DOMString* value)
  {
    return; //TODO
  }

  void Element::removeAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return; //TODO
  }
  AttributeP Element::getAttributeNodeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return false; //TODO
  }

  AttributeP Element::setAttributeNodeNS(AttributeP newAttr)
  {
    return NULL; //TODO
  }

  NodeList*  Element::getElementsByTagNameNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    //TODO:
    NodeList *tmp = new NodeList();
    return tmp;
  }

  bool Element::hasAttribute(DOMString* name)
  {
    return false; //TODO
  }

  bool Element::hasAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return false; //TODO
  }

  
}
