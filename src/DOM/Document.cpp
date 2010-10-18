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

#include <iostream>

#include "DOM/DOMAllInc.h"

using namespace std;

namespace DOM
{

  Document::Document( DocumentType*       doctype,
                      DOMImplementation*  implementation
                    ):
    Node(new DOMString("#document"), Node::DOCUMENT_NODE, NULL, NULL, NULL, NULL, NULL),
    _doctype(doctype),
    _implementation(implementation),
    _attributeDefaultQualified(false),
    _elementDefaultQualified(false),
    _currentElement(NULL),
    _stateful(false),
    _buildingFromInputStream(false),
    _prettyPrint(false)
  {

  }

  void Document::startDocument()
  {
    _buildingFromInputStream = true;
  }

  //FIXME: valgrind shows invalid read in this function
  void Document::endDocument()
  {
    // remove duplicates among prefixedNamespaces and unprefixedNamespaces
    list<DOMString>::iterator it = _unprefixedNamepspaces.begin();
    for( ; it != _unprefixedNamepspaces.end(); ++it)
    {
      map<DOMString, DOMString>::iterator it2 = _prefixedNamespaces.begin();
      for( ; it2 != _prefixedNamespaces.end(); ++it2)
      {
        if(it2->second == *it) {
          //delete from list
          _unprefixedNamepspaces.erase(it);
          --it;
          break;
        }
      }
    }

    // build from input stream done
    _buildingFromInputStream = false;
  }

  ElementP Document::createElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
  {
    Node* parentNode = NULL;
    if(_stateful) { 
      if(_currentElement) {
        parentNode = _currentElement;
      }
      else {
        parentNode = this;
      }
    }
    ElementP elemNode = new Element(localName, nsUri, nsPrefix, this, parentNode);
    if(_stateful){
      _currentElement = elemNode;
    }
    return elemNode;
  }
  
  ElementP Document::createElement(DOMString* tagName)
  {
    return createElementNS(NULL, NULL, tagName);
  }
  
  ElementP Document::createElementNS(DOMString* nsUri, DOMString* qualifiedName)
  {
    if(!qualifiedName) {
      // TODO: throw exception
      return NULL;
    }
    vector<XPlus::UString> tokens;
    qualifiedName->tokenize(':', tokens);
    assert(tokens.size()==2);
    return createElementNS(nsUri, new DOMString(tokens[0]), new DOMString(tokens[1]));
  }
    
  void Document::endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName)
  {
    if(_stateful) {
      if(_currentElement && _currentElement->getParentNode()) {
        //_currentElement = dynamic_cast<ElementP>(_currentElement->getParentNode().get()); 
        _currentElement = dynamic_cast<ElementP>(_currentElement->getParentNode()); 
      }
      else {
        //TODO: throw exception: found an element end without a context _currentElement
      }
    }
  }

  AttributeP Document::createAttributeNS(DOMString* nsUri, 
      DOMString* nsPrefix, 
      DOMString* localName,
      DOMString* value )
  {
    ElementP ownerElement = NULL;
    
    if(_stateful) { 
      if(_currentElement) {
        ownerElement = _currentElement;
      }
      else {
        //TODO: throw exception : attrNode without owner element
      }
    }
    return new Attribute( localName, value, nsUri, nsPrefix, ownerElement, this);
  }
  
  AttributeP Document::createAttributeNS(DOMString* nsUri,
      DOMString* qualifiedName)
  {
    return NULL; //TODO:
  }

  AttributeP Document::createAttribute(DOMString* name)
  {
    return createAttributeNS(NULL, NULL, name, NULL);
  }

  DocumentFragment* Document::createDocumentFragment()
  {
    return NULL; //TODO:
  }
  
  TextNodeP Document::createTextNode(DOMString* data)
  {
    Node* parentNode = NULL;
    if(_stateful) { 
      if(_currentElement) {
        parentNode = _currentElement;
      }
      else {
        parentNode = this;
      }
    }
    TextNode* txt = new TextNode(data, this, parentNode);
    return txt;
    //return new TextNode(data, this, parentNode);
  }
  
  Comment* Document::createComment(DOMString* data)
  {
    Node* parentNode = NULL;
    if(_stateful) { 
      if(_currentElement) {
        parentNode = _currentElement;
      }
      else {
        parentNode = this;
      }
    }
    return new Comment(data, this, parentNode);
  }
  
  CDATASection* Document::createCDATASection(DOMString* data)
  {
    return NULL; //TODO:
  }

  PI* Document::createProcessingInstruction(DOMString* target,
      DOMString* data)
  {
    return new PI(target, data, this);
  }
  
  EntityRef* Document::createEntityReference(DOMString* name)
  {
    return NULL; //TODO:
  }
  
  NodeList* Document::getElementsByTagName(DOMString* tagname)
  {
    return NULL; //TODO:
  }

  // Introduced in DOM Level 2:
  Node* Document::importNode(Node* importedNode, bool deep)
  {
    return NULL; //TODO:
  }
  

  NodeList* Document::getElementsByTagNameNS(DOMString* namespaceURI,
      DOMString* localName)
  {
    return NULL; //TODO:
  }

  ElementP Document::getElementById(DOMString* elementId)
  {
    return NULL; //TODO
  }
  
  const Element* Document::getDocumentElement() const 
  {
    if(getChildNodes().getLength() > 0) {
      return dynamic_cast<ElementP>(const_cast<Node*>(getChildNodes().item(0)));
      //return dynamic_cast<ElementP>(getChildNodes().item(0));
    }
    return NULL;
  }
  
  ElementP Document::getDocumentElement()  
  {
    if(getChildNodes().getLength() > 0) {
      return dynamic_cast<ElementP>(getChildNodes().item(0));
      //return dynamic_cast<ElementP>(getChildNodes().item(0));
    }
    return NULL;
  }

  void Document::addPrefixedNamespace(DOMString nsPrefixStr, DOMString nsUriStr) {
    //TODO: improve eg. use some hash than lookup each time to check presence
    _prefixedNamespaces.insert(std::pair<DOMString, DOMString>(nsPrefixStr, nsUriStr));
  }

    
  void Document::addUnprefixedNamespace(DOMString nsUriStr) {
    //TODO: improve eg. use some hash than lookup each time to check presence
    list<DOMString>::const_iterator it = _unprefixedNamepspaces.begin();
    for( ; it != _unprefixedNamepspaces.end(); it++)
    {
      if(*it == nsUriStr) {
        return;
      }
    }

    _unprefixedNamepspaces.push_back(nsUriStr);
    /*
    ostringstream nsPrefix;
    nsPrefix << "ns" << _unprefixedNamepspaces.size()+1;
    _unprefixedNamepspaces.insert(std::pair<DOMString, DOMString>( DOMString(nsPrefix.str()), nsUriStr) );
    */
  }
  
  void Document::registerNsPrefixNsUri(DOMString* nsPrefix, DOMString* nsUri)
  {
    if(!nsUri) {
      return;
    }
    if(!nsPrefix) {
      addUnprefixedNamespace(*nsUri); 
    }
    else {
      addPrefixedNamespace(*nsPrefix, *nsUri);
    }
  }

  DOMString Document::getImplicitNsPrefixForNsUri(DOMString nsUriStr) const
  {
    list<DOMString>::const_iterator it = _unprefixedNamepspaces.begin();
    unsigned int i = _prefixedNamespaces.size() + 1;
    for( ; it != _unprefixedNamepspaces.end(); it++, i++)
    {
      if(*it != nsUriStr) {
        continue;
      }

      ostringstream oss;
      oss << "ns" << i;
      DOMString nsPrefix = oss.str();
      while(1) 
      {
        ostringstream oss;
        oss << "ns" << i;
        nsPrefix = oss.str();
        if(!isPrefixTaken(nsPrefix)) {
          return nsPrefix;
        }
        i++;
      }
      return DOMString(oss.str());
    }
    return "";
  }
    
  bool Document::isPrefixTaken(DOMString nsPrefixStr) const
  {
    return (_prefixedNamespaces.find(nsPrefixStr) != _prefixedNamespaces.end());
  }

  DOMString* Document::getDocumentElementNsUri()  {
    if(this->getDocumentElement()) {
      return getDocumentElement()->getNamespaceURI();
    }
    return NULL;
  }
  
  const DOMString* Document::getDocumentElementNsUri() const {
    if(this->getDocumentElement()) {
      return getDocumentElement()->getNamespaceURI();
    }
    return NULL;
  }

}
