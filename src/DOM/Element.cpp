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
    XPlusObject("Element"),  
    Node(tagName, Node::ELEMENT_NODE, nsURI, nsPrefix, ownerDocument, NULL, parentNode, prevSibling, nextSibling),
    _tagName(tagName)
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
      DOMString* value) 
  {
    Attribute* pAttr = new Attribute(name, value);
    this->setAttributeNode(pAttr);
  }

  void Element::removeAttribute(DOMString* name)
  {
    _attributes.removeNamedItem(name);
  }

  Attribute*  Element::getAttributeNode(DOMString* name)
  {
    return dynamic_cast<Attribute *>(_attributes.getNamedItem(name));
  }

  Attribute*  Element::setAttributeNode(Attribute* newAttr)
  {
    _attributes.setNamedItem(newAttr);
    return newAttr;
  }

  Attribute*  Element::removeAttributeNode(Attribute*  oldAttr)
  {
    return NULL; //TODO
  }


  // Introduced in DOM Level 2:
  const DOMString* Element::getAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    Node* pAttr = _attributes.getNamedItemNS(namespaceURI, localName);
    if(pAttr) {
      return pAttr->getNodeValue();
    }
    return NULL;
  }

  void Element::setAttributeNS(DOMString* namespaceURI,
      DOMString* qualifiedName,
      DOMString* value)
  {
    //TODO: split qualifiedName to get localName ... then
    //Attribute* pAttr = new Attribute(localName, value, namespaceURI);
    //this->setAttributeNode(pAttr);
    return; 
  }

  void Element::removeAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    _attributes.removeNamedItemNS(namespaceURI, localName);
  }

  Attribute*  Element::getAttributeNodeNS(DOMString* namespaceURI, DOMString* localName)
  {
    return dynamic_cast<Attribute *>(_attributes.getNamedItemNS(namespaceURI, localName));
  }

  Attribute*  Element::setAttributeNodeNS(Attribute* newAttr)
  {
    _attributes.setNamedItem(newAttr);
    return newAttr;
  }

  NodeList*  Element::getElementsByTagNameNS(DOMString* namespaceURI, DOMString* localName)
  {
    //TODO:
    NodeList *tmp = new NodeList();
    return tmp;
  }

  bool Element::hasAttribute(DOMString* name)
  {
    return (getAttributeNode(name) != NULL);
  }

  bool Element::hasAttributeNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return (getAttributeNodeNS(namespaceURI, localName) != NULL);
  }

  Element* Element::copy(DOMString* tagName, Document* ownerDocument, Node* parentNode, Node* prevSibling, Node* nextSibling)
  {
      Element* res = new Element(tagName ? tagName : new DOMString(*getTagName()),
              getNamespaceURI()?new DOMString(*getNamespaceURI()):NULL,
              getNamespacePrefix()?new DOMString(*getNamespacePrefix()):NULL,
              ownerDocument, parentNode, prevSibling, nextSibling);

      Node* lastInsertedChild = NULL;

      for (unsigned int i = 0 ; i < getChildNodes().getLength() ; i++)
      {
          Node* child = getChildNodes().item(i);
          if (dynamic_cast<Element*>(child))
          {
              Element* childElt = dynamic_cast<Element*>(child);
              lastInsertedChild = childElt->copy(NULL, ownerDocument, res, lastInsertedChild, NULL);
          }
      }

      const NamedNodeMap& atts = getAttributes();
      for(unsigned int i = 0; i < atts.length(); i++)
      {
          const Node* attr = atts.item(i);
          if(attr)
          {
              const Attribute* childAttr = dynamic_cast<const Attribute*>(attr);
              new Attribute(new DOMString(*(childAttr->getName())),
                      childAttr->getValue()?new DOMString(*(childAttr->getValue())):NULL,
                      childAttr->getNamespaceURI()?new DOMString(*(childAttr->getNamespaceURI())):NULL,
                      childAttr->getNamespacePrefix()?new DOMString(*(childAttr->getNamespacePrefix())):NULL,
                      res, ownerDocument);
          }
      }

      for (unsigned int i = 0 ; i < getChildNodes().getLength() ; i++)
      {
          Node* child = getChildNodes().item(i);
          if (dynamic_cast<TextNode*>(child))
          {
              TextNode* childTxt = dynamic_cast<TextNode*>(child);
              new TextNode(new DOMString(*(childTxt->getNodeValue())), ownerDocument, res, NULL);
          }
          else if (dynamic_cast<CDATASection*>(child))
          {
              CDATASection* childTxt = dynamic_cast<CDATASection*>(child);
              new CDATASection(new DOMString(*(childTxt->getNodeValue())), ownerDocument, res, NULL);
          }
      }

      return res;
  }

  
}
