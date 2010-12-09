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

#include "XSD/xsdUtils.h"

namespace XMLSchema
{
  TElementP TDocument::currentElement() {
    return dynamic_cast<TElement *>(_currentElement);
  }
  void TDocument::currentElement(ElementP elem) {
    _currentElement = elem;
  }

  void TDocument::startDocument()
  {
    //cout << "startDocument" << endl;
  }
  
  void TDocument::endDocument()
  {
    //cout << "endDocument" << endl;
    DOM::Document::endDocument();

    if(_currentElement) {
      currentElement()->endDocument();  
    }
    /*
    if(_fsm) {
      _fsm->processDocumentEndEvent();  
    }
    */
  }

  TextNodeP TDocument::createTextNode(DOMString* data)
  {
    if(currentElement()) {
      return currentElement()->createTextNode(data);
    }
    return NULL;
  }
    
  Element* TDocument::createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)
  {
    if(!localName) {
      throw XPlus::NullPointerException("createElementWithAttributes: localName is NULL");
    }

    if(currentElement()) {
      _currentElement = currentElement()->createElementWithAttributes(nsUri, nsPrefix, localName, attrVec);
      return _currentElement;
    }

    // reaching here would mean that this element to be created is a document-element. 
    // Also should reach here only once for one input document.
    // So create the element and add attributes to it
    XsdEvent event(nsUri, nsPrefix, *localName, XsdEvent::ELEMENT_START);
    if(_fsm && _fsm->processEventThrow(event))
    {
      if(_fsm->fsmCreatedNode()) 
      {
        _currentElement = dynamic_cast<Element *>(const_cast<Node*>(_fsm->fsmCreatedNode()));
        _fsm->fsmCreatedNode(NULL);
      }
    }
    // shouldn't come here as the previous processEventThrow call will either
    // go through or will throw an exception.
    // Adding this block just to be safe.
    else
    {
      ostringstream err;
      err << "Unexpected Element: " << formatNamespaceName(XsdEvent::ELEMENT_START, nsUri, *localName);
      throw XMLSchema::FSMException(DOMString(err.str()));
    }
      
    // now add attributes to this element  
    for(unsigned int i=0; i<attrVec.size(); i++)
    {
      AttributeInfo& attrInfo = attrVec[i];
      currentElement()->createAttributeNS(const_cast<DOMString *>(attrInfo.nsUri()),
                                    const_cast<DOMString *>(attrInfo.nsPrefix()),
                                    const_cast<DOMString *>(attrInfo.localName()),
                                    const_cast<DOMString *>(attrInfo.value()) );
    }
    
    //TODO: create attributes

    return _currentElement;
  }

  /*
  ElementP TDocument::createElementNS(DOMString* nsUri, 
      DOMString* nsPrefix, 
      DOMString* localName) 
  {
    if(!localName) {
      throw XPlus::NullPointerException("createElementNS: localName is NULL");
    }

    if(currentElement()) {
      _currentElement = currentElement()->createElementNS(nsUri, nsPrefix, localName);
      return _currentElement;
    }

    XsdEvent event(nsUri, nsPrefix, *localName, XsdEvent::ELEMENT_START);
    if(_fsm && _fsm->processEventThrow(event))
    {
      if(_fsm->fsmCreatedNode()) 
      {
        _currentElement = dynamic_cast<Element *>(const_cast<Node*>(_fsm->fsmCreatedNode()));
        _fsm->fsmCreatedNode(NULL);
        return _currentElement;
      }
    }

    ostringstream err;
    err << "Unexpected Element: " << formatNamespaceName(XsdEvent::ELEMENT_START, nsUri, *localName);
    throw XMLSchema::FSMException(DOMString(err.str()));
  }

  Attribute* TDocument::createAttributeNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, DOMString* value)
  {
    if(!localName) {
      //TODO: throw exception
      return NULL;
    }

    if(currentElement()) {
      return currentElement()->createAttributeNS(nsUri, nsPrefix, localName, value);
    }

    XsdEvent event(nsUri, nsPrefix, *localName, XsdEvent::ATTRIBUTE);
    if(_fsm && _fsm->processEventThrow(event))
    {
      if(_fsm->fsmCreatedNode()) 
      {
        Attribute* attr = dynamic_cast<Attribute *>(const_cast<Node*>(_fsm->fsmCreatedNode()));
        _fsm->fsmCreatedNode(NULL);
        if(attr) {
          attr->createChildTextNode(value);
          return attr;
        }
      }
    }

    ostringstream err;
    err << "Unexpected : " << formatNamespaceName(XsdEvent::ATTRIBUTE, nsUri, *localName) ;
    throw XMLSchema::FSMException(DOMString(err.str()));
  }
  */


  void TDocument::endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
  {
    if(currentElement()) {
      currentElement()->endElementNS(nsUri, nsPrefix, localName);
      //_currentElement = dynamic_cast<ElementP>(_currentElement->getParentNode().get()); 
      _currentElement = dynamic_cast<ElementP>(_currentElement->getParentNode()); 
    }
    else {
      throw XMLSchema::FSMException("Found end-of-Element without the context of that Element");
    }
  }

}
