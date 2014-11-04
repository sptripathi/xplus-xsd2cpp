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

#include "DOM/DOMAllInc.h"
#include "Poco/Bugcheck.h"

using namespace std;

namespace DOM
{

  Document::Document( DocumentType*       doctype,
                      DOMImplementation*  implementation
                    ):
    XPlusObject("Document"),                
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

  Element* Document::createElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
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
    Element* elemNode = new Element(localName, nsUri, nsPrefix, this, parentNode);
    if(_stateful){
      _currentElement = elemNode;
    }
    return elemNode;
  }
  
  Element* Document::createElement(DOMString* tagName)
  {
    return createElementNS(NULL, NULL, tagName);
  }
  
  Element* Document::createElementNS(DOMString* nsUri, DOMString* qualifiedName)
  {
    if(!qualifiedName) {
      throw DOMException("createElementNS: qualifiedName arg is NULL");
    }
    vector<XPlus::UString> tokens;
    qualifiedName->tokenize(':', tokens);
    poco_assert(tokens.size()==2);
    return createElementNS(nsUri, new DOMString(tokens[0]), new DOMString(tokens[1]));
  }
      
  Element* Document::createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)
  {
    Element* elemNode = this->createElementNS(nsUri, nsPrefix, localName);
    if(!elemNode) {
      ostringstream err;
      err << "failed to create element ["  << *localName << "] ";
      throw DOMException(err.str());
    }

    for(unsigned int i=0; i<attrVec.size(); i++)
    {
      AttributeInfo& attrInfo = attrVec[i];
      Attribute* attrNode = this->createAttributeNS(const_cast<DOMString *>(attrInfo.nsUri()),
          const_cast<DOMString *>(attrInfo.nsPrefix()),
          const_cast<DOMString *>(attrInfo.localName()),
          const_cast<DOMString *>(attrInfo.value()));

      if(!attrNode) {
        ostringstream err;
        err << "failed to create attribute ["  << *attrInfo.localName() << "] ";
        throw DOMException(err.str());
      }
    }
    return elemNode;
  }
    
  void Document::endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName)
  {
    if(_stateful) {
      if(_currentElement && _currentElement->getParentNode()) {
        _currentElement = dynamic_cast<Element*>(_currentElement->getParentNode()); 
      }
      else {
        throw DOMException("endElementNS: found end of an element end without context");
      }
    }
  }

  AttributeP Document::createAttributeNS(DOMString* nsUri, 
      DOMString* nsPrefix, 
      DOMString* localName,
      DOMString* value )
  {
    Element* ownerElement = NULL;
    
    if(_stateful) { 
      if(_currentElement) {
        ownerElement = _currentElement;
      }
      else {
        throw DOMException("createAttributeNS: found an attrNode without any owner element");
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

  CDATASection* Document::createCDATASection(DOMString* data)
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
    return new CDATASection(data, this, parentNode);
  }

  DocumentType* Document::createDocumentType(
        const DOMString*      name,
        NamedNodeMap          entities,
        NamedNodeMap          notations,
        const DOMString*      publicId,
        const DOMString*      systemId,
        const DOMString*      internalSubset)
  {
    _doctype = new DocumentType(name, entities, notations, publicId, systemId, internalSubset, this);
    return _doctype;
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

  Element* Document::getElementById(DOMString* elementId)
  {
    return NULL; //TODO
  }
  
  const Element* Document::getDocumentElement() const 
  {
    if (getChildNodes().getLength() > 0)
	{
		for (int i = 0; i < getChildNodes().getLength(); i++)
		{
			if(Node::COMMENT_NODE == getChildNodes().item(i)->getNodeType())
			{
				continue;
			}
			else
			{
				return dynamic_cast<Element*> (const_cast<Node*> (getChildNodes().item(i)));
      //return dynamic_cast<Element*>(getChildNodes().item(0));
    }
		}
	}
    return NULL;
  }
  
  Element* Document::getDocumentElement()  
  {
    if(getChildNodes().getLength() > 0) {
		for (int i = 0; i < getChildNodes().getLength(); i++)
		{
			if(Node::COMMENT_NODE == getChildNodes().item(i)->getNodeType())
			{
				continue;
			}
			else
			{
				return dynamic_cast<Element*>(getChildNodes().item(i));
      //return dynamic_cast<Element*>(getChildNodes().item(0));
    }
		} 
    }
    return NULL;
  }

  void Document::addPrefixedNamespace(DOMString nsPrefixStr, DOMString nsUriStr) {
    //TODO: improve eg. use some hash than lookup each time to check presence
    _prefixedNamespaces.insert(std::pair<DOMString, DOMString>(nsPrefixStr, nsUriStr));
  }

  const DOMString Document::getNsUriForNsPrefixExplicit(const DOMString nsPrefix) const
  {
    std::map<DOMString, DOMString>::const_iterator cit = _prefixedNamespaces.find(nsPrefix);
    std::map<DOMString, DOMString>::const_iterator end = _prefixedNamespaces.end();
    if(cit == end) {
      return "";
    }
    return cit->second;
  }
      
  const DOMString Document::getNsPrefixForNsUriExplicit(const DOMString nsUri) const
  {
    map<DOMString, DOMString>::const_iterator it = _prefixedNamespaces.begin();
    for( ; it != _prefixedNamespaces.end(); ++it)
    {
      if(nsUri == it->second) {
        return it->first;
      }
    }
    return "";
  }

  const DOMString Document::getNsPrefixForNsUriImplicit(const DOMString nsUriStr) const
  {
    DOMString explicitNsPrefix = getNsPrefixForNsUriExplicit(nsUriStr);
    if(explicitNsPrefix.length()>0) {
      return explicitNsPrefix;
    }

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
    //ostringstream nsPrefix;
    //nsPrefix << "ns" << _unprefixedNamepspaces.size()+1;
    //_unprefixedNamepspaces.insert(std::pair<DOMString, DOMString>( DOMString(nsPrefix.str()), nsUriStr) );
  }
  
  void Document::registerNsPrefixNsUri(const DOMString* nsPrefix, const DOMString* nsUri)
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
