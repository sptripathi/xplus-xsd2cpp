// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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

    virtual ~TElement() {}  

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
  

  class XmlElement :  public TElement
  {
    protected:

    private:

	XMLSchema::Types::anyType* userObj;

    public:

      XmlElement(ElementCreateArgs args):
          TElement(args), userObj(0)
    { 
    }

      virtual ~XmlElement() 
       {
		delete userObj;
		userObj = 0;
	}
       
      virtual XMLSchema::Types::anyType* userObject()
	{
		return userObj;
	}

	virtual void userObject(XMLSchema::Types::anyType* obj)
{
	userObj = obj;
}
 
      //
      // TElement interface: delegates the call to T
      //
     
      virtual TDocumentP ownerDocument() {
        return userObj->ownerDocument();
      }
      virtual TElementP ownerElement() {
        return userObj->ownerElement();
      }
      
      virtual TElement* createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)
      {
        try {
          return userObj->createElementWithAttributes(nsUri, nsPrefix, localName, attrVec);
        }
        catch(XPlus::Exception& ex) 
        {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
      }

      virtual inline void endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
      {
        userObj->endElementNS(nsUri, nsPrefix, localName);
      }

      virtual AttributeP createAttributeNS(DOMString* nsUri,
          DOMString* nsPrefix, 
          DOMString* localName, 
          DOMString* value) 
      {
        try {
          return userObj->createAttributeNS(nsUri, nsPrefix, localName, value);
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
        userObj->endDocument();
      }

      virtual inline TextNodeP createTextNode(DOMString* data) 
      {
        try {
          return userObj->createTextNode(data);
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
          return userObj->createCDATASection(data);
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

