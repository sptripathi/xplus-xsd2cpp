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

#ifndef __XSD_UTILS_H__ 
#define __XSD_UTILS_H__

#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <list>

#include "XPlus/AutoPtr.h"

#include "DOM/DOMAllInc.h"
#include "XSD/XSDException.h"
#include "XSD/XSDFSM.h"
#include "XSD/PrimitiveTypes.h"

using namespace std;
using namespace XPlus;
using namespace FSM;


/*
        DOM::Element
            ^
            |
            |
          TElement    T (anyType or derivations)           
            ^                 ^
            |                 | 
            |                 |
            \                /
             \              /
              \            / 
               \          /
                XmlElement

        
      DOM::Attribute     T (anyType or derivations)           
            ^                 ^
            |                 | 
            |                 |
            \                /
             \              /
              \            / 
               \          /
                XmlAttribute


 */  

// Implementation Note:
// Every XSD-Element is-a(derivation) XmlElement<T> 
// Every XSD-Attribute is-a(derivation) XmlAttribute<T>


namespace XMLSchema
{
  //forward declarations
  class TElement;
  class TDocument;
  
  typedef AutoPtr<TElement> TElementPtr;
  typedef AutoPtr<TDocument> TDocumentPtr;
  typedef TElement* TElementP;
  typedef TDocument* TDocumentP;

  template <class T>
    class XmlAttribute : public DOM::Attribute, public T
  {
    public:

      XmlAttribute(DOMString* name, 
          DOMStringP nsUri=NULL,
          DOMStringP nsPrefix=NULL,
          ElementP ownerElem= NULL,
          TDocumentP ownerDoc= NULL,
          DOMString* strValue=NULL
          ):
        DOM::Attribute(name, strValue, nsUri, nsPrefix, ownerElem, ownerDoc),
        T(this, ownerElem, ownerDoc)
      { 
        if(strValue) {
          T::stringValue(*strValue);
        }
      }

      virtual ~XmlAttribute() {}

      virtual inline TextNodeP createTextNode(DOMString* data) 
      {
        try {
          return T::createTextNode(data);
        }
        catch(XPlus::Exception& ex) 
        {
          ex.setContext("attribute", *this->ownerNode()->getNodeName());
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
      }

      inline void print() {
        cout << "XmlAttribute:"
          << " name=" << getLocalName()
          << endl;
      }
  };


  class TDocument : public DOM::Document
  {
    protected:
      bool _buildTree;
      XsdFsmBasePtr  _fsm;
      
      //scratchPad variables
      //Node*           _fsmCreatedNode;

    public:
      TDocument(bool buildTree=true):
        _buildTree(buildTree),
        _fsm(NULL)
        //, _fsmCreatedNode(NULL)
    {
    }

      virtual ~TDocument(){}

      inline void buildTree(bool b) {
        _buildTree = b;
      }
      inline bool buildTree() const {
        return _buildTree;
      }

      inline TElementP currentElement();
      inline void currentElement(ElementP elem);

      virtual TextNodeP createTextNode(DOMString* data);
      virtual ElementP createElementNS(DOMString* nsUri, 
        DOMString* nsPrefix, 
        DOMString* localName); 
      virtual AttributeP createAttributeNS(DOMString* namespaceURI,
          DOMString* nsPrefix, DOMString* localName, DOMString* value);
      void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName);
      void startDocument();
      void endDocument();

  };


  // =========================== TElement ===========================

  // Document's DOMEvent handlers (eg createElementNS, endElementNS
  // etc.) are delegated to current-element's corresponding handler
  // while building the DOM.
  // This BaseClass of any XSD element is needed to force Document's 
  // DOMEvent handlers interface on XSD elements. 
  class TElement : public DOM::Element
  {
    protected:

    public:

      //NB: 
      // previousSiblingElement : is previousSibling to this TElement
      TElement(
          DOMString* tagName,
          DOMString* nsUri =NULL, 
          DOMString* nsPrefix=NULL,
          TDocument*   ownerDoc=NULL,
          Node*        parentNode=NULL,
          Node*        previousSiblingElement=NULL,
          Node*        nextSiblingElement=NULL
          ):
        DOM::Element(tagName, nsUri, nsPrefix, ownerDoc, parentNode, previousSiblingElement, nextSiblingElement)
    {
#if 0
      // child is likely to override _fsm allocation
        XsdFsmBasePtr elemEndFsm = new XsdFSM<void *>(NSNamePairOccur(nsUri, *tagName, 1, 1), XsdFsmBase::ELEMENT_END);
        XsdFsmBasePtr ptrFsms[] = { elemEndFsm, NULL };
        _fsm = new XsdFsmOfFSMs(ptrFsms, XsdFsmOfFSMs::SEQUENCE);
#endif
    }

    virtual ~TElement() {}  

    virtual TDocumentP ownerDocument() =0;
    virtual TElementP ownerElement() =0; 
      
    virtual TElementP createElementNS(DOMString* nsUri, 
        DOMString* nsPrefix, 
        DOMString* localName) =0; 


    virtual void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName) =0;

    virtual AttributeP createAttributeNS(DOMString* namespaceURI,
        DOMString* nsPrefix, DOMString* localName, DOMString* value) =0;

    virtual void endDocument() =0;
      
    virtual TextNodeP createTextNode(DOMString* data) =0;
  };
  

  template <class T>
    class XmlElement :  public TElement, public T
  {
    protected:

    public:

      XmlElement(
          DOMString* tagName,
          DOMString* nsUri =NULL, 
          DOMString* nsPrefix=NULL,
          TDocumentP ownerDoc=NULL,
          NodeP      parentNode=NULL,
          Node*      previousSibling=NULL,
          Node*      nextSibling=NULL
          ):
        TElement(tagName, nsUri, nsPrefix, ownerDoc, parentNode, previousSibling, nextSibling),
        T(this, this, ownerDoc)
    { 
    }

      virtual ~XmlElement() {}
        
      //
      // TElement interface: delegates the call to T
      //
     
      virtual TDocumentP ownerDocument() {
        return T::ownerDocument();
      }
      virtual TElementP ownerElement() {
        return T::ownerElement();
      }
      
      virtual inline TElementP createElementNS(DOMString* nsURI, 
          DOMString* nsPrefix, 
          DOMString* localName) 
      {
        try {
          return T::createElementNS(nsURI, nsPrefix, localName);
        }
        catch(XPlus::Exception& ex) 
        {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
      }

      virtual inline void endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
      {
        T::endElementNS(nsUri, nsPrefix, localName);
      }

      virtual AttributeP createAttributeNS(DOMString* nsUri,
          DOMString* nsPrefix, 
          DOMString* localName, 
          DOMString* value) 
      {
        try {
          return T::createAttributeNS(nsUri, nsPrefix, localName, value);
        }
        catch(XPlus::Exception& ex) 
        {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          ex.setContext("attribute", *localName);
          throw ex;
        }
      }

      virtual inline void endDocument() 
      {
        T::endDocument();
      }

      virtual inline TextNodeP createTextNode(DOMString* data) 
      {
        try {
          return T::createTextNode(data);
        }
        catch(XPlus::Exception& ex) 
        {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
      }

      inline void print() {
        cout << "XmlElement:"
          << " name=" << getLocalName()
          << endl;
      }
  };


} // end namespace XMLSchema

//typedef XMLSchema::TDocument* TDocumentP;

#endif /* __XSD_UTILS_H__ */  

