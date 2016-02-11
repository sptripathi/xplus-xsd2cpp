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

#include "XSD/xsdUtils.h"
#include "XSD/TypeDefinitionFactory.h"

namespace XMLSchema
{
  TDocument::~TDocument()
  {
    //XSD::TypeDefinitionFactory::freeMap();
  }

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
    FsmCbOptions& cbOptions = event.cbOptions;
    // set the xsi context to be passed to callback functions.
    for(unsigned int i=0; i<attrVec.size(); i++)
    {
      if(!attrVec[i].nsUri() || (*attrVec[i].nsUri() != Namespaces::s_xsiUri) ) {
        continue;
      }
      if(attrVec[i].localName() && (*attrVec[i].localName() == Namespaces::s_xsiTypeStr) && attrVec[i].value()) 
      {
        cbOptions.xsiType = *attrVec[i].value();
      }
      else if(attrVec[i].localName() && (*attrVec[i].localName() == Namespaces::s_xsiNilStr) && attrVec[i].value()) 
      {
        cbOptions.xsiNil = *attrVec[i].value();
      }
      else if(attrVec[i].localName() && (*attrVec[i].localName() == Namespaces::s_xsiSchemaLocationStr) && attrVec[i].value()) 
      {
        cbOptions.xsiSchemaLocation = *attrVec[i].value();
      }
      else if(attrVec[i].localName() && (*attrVec[i].localName() == Namespaces::s_xsiNoNamespaceSchemaLocationStr) && attrVec[i].value()) 
      {
        cbOptions.xsiNoNamespaceSchemaLocation = *attrVec[i].value();
      }
    }

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
