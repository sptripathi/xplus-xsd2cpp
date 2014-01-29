// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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
#include "XSD/UrTypes.h"

using namespace std;
using namespace XPlus;
using namespace FSM;
using namespace XMLSchema::Types;


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
// Every XMLObject corresponding to an Element, is-a(derivation) XmlElement<T> 
// Every XMLObject corresponding to an Attribute is-a(derivation) XmlAttribute<T>


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

      XmlAttribute(AttributeCreateArgs args):
        DOM::Attribute(args.name, args.strValue, args.nsUri, args.nsPrefix, args.ownerElem, args.ownerDoc),
        T(AnyTypeCreateArgs(true, this, args.ownerElem, args.ownerDoc, false,false,
                            BOF_NONE, BOF_NONE, CONTENT_TYPE_VARIETY_MIXED, ANY_TYPE,
                            false, args.isSampleCreate)
        )
      { 
        if(args.strValue) {
          T::stringValue(*args.strValue);
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

      virtual inline CDATASection* createCDATASection(DOMString* data) 
      {
        try {
          return T::createCDATASection(data);
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
      bool _createSample;
      XsdFsmBasePtr  _fsm;
      
      //scratchPad variables
      //Node*           _fsmCreatedNode;

    public:
      TDocument(bool buildTree=true, bool createSample=false):
        _buildTree(buildTree),
        _createSample(createSample),
        _fsm(NULL)
        //, _fsmCreatedNode(NULL)
    {
    }

      virtual ~TDocument();

      inline void buildTree(bool b) {
        _buildTree = b;
      }
      inline bool buildTree() const {
        return _buildTree;
      }
      
      inline void createSample(bool b) {
        _createSample = b;
      }
      inline bool createSample() const {
        return _createSample;
      }

      inline TElementP currentElement();
      inline void currentElement(ElementP elem);

      virtual TextNodeP createTextNode(DOMString* data);
      
      virtual Element* createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec);

      //virtual AttributeP createAttributeNS(DOMString* namespaceURI, DOMString* nsPrefix, DOMString* localName, DOMString* value);
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

      bool   _abstract;
      bool   _nillable;
      bool   _fixed;

    public:

      // constructor 
      // NB: 
      // previousSiblingElement : is previousSibling to this TElement
    TElement(ElementCreateArgs args):
        DOM::Element(args.name, args.nsUri, args.nsPrefix, args.ownerDoc, args.parentNode, args.previousSiblingElement, args.nextSiblingElement),
        _abstract(args.abstract),
        _nillable(args.nillable),
        _fixed(args.fixed)
    {
      if(abstract())
      {
        ValidationException ex("The element can not be used in the instance document because it is declared abstract in the schema document. A member of this element's substitution group must appear in the instance document");
        if(this->getParentNode()) {
          this->getParentNode()->removeChild(this);  
        }
        throw ex;
      }
    }

    TElement() {printf("TElement::TElement()\n");};

    virtual ~TElement() {};

    virtual TDocumentP ownerDocument() =0;
    virtual TElementP ownerElement() =0; 
      
    virtual Element* createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)=0;

    virtual void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName) =0;

    virtual AttributeP createAttributeNS(DOMString* namespaceURI,
        DOMString* nsPrefix, DOMString* localName, DOMString* value) =0;

    virtual void endDocument() =0;
      
    virtual TextNodeP createTextNode(DOMString* data) =0;

    inline bool abstract() {
      return _abstract;
    }
    inline bool nillable() {
      return _nillable;
    }
    inline bool fixed() {
      return _fixed;
    }
  };
  
  //XMLSchema::XmlElement<XMLSchema::Types::anyType>::XmlElement()

  template <class T> class XmlElement :  public TElement, public T
  {
    protected:

    public:

      XmlElement(ElementCreateArgs args):
          TElement(args),
          T(AnyTypeCreateArgs(true, this, this, args.ownerDoc, args.childBuildsTree, false, 
                              Types::BOF_NONE, Types::BOF_NONE, Types::CONTENT_TYPE_VARIETY_MIXED, 
                              Types::ANY_TYPE, args.suppressTypeAbstract, args.isSampleCreate)
           )
    {
        printf("XMLSchema::XmlElement::XmlElement(XMLSchema::Types::ElementCreateArgs)\n");
        cout << args.name->str() << endl;
    }

      XmlElement() {printf("XmlElement::XmlElement()\n");};

      virtual ~XmlElement() {};
        
      //
      // TElement interface: delegates the call to T
      //
     
      virtual TDocumentP ownerDocument() {
        return T::ownerDocument();
      }
      virtual TElementP ownerElement() {
        return T::ownerElement();
      }
      
      virtual TElement* createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)
      {
        try {
          return T::createElementWithAttributes(nsUri, nsPrefix, localName, attrVec);
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

      virtual inline CDATASection* createCDATASection(DOMString* data) 
      {
        try {
          return T::createCDATASection(data);
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

