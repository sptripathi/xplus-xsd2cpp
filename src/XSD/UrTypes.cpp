// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2011   Satya Prakash Tripathi
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

#include "XPlus/Namespaces.h"
#include "XSD/PrimitiveTypes.h"
#include "XSD/xsdUtils.h"
#include "XSD/XSDException.h"
#include "XSD/TypeDefinitionFactory.h"
#include "Poco/RegularExpression.h"

extern "C" {
#include <ctype.h>
}

using namespace std;
using XPlus::Namespaces;

XSD::MapWrapper  XSD::TypeDefinitionFactory::_map;

namespace XMLSchema
{

  template<> void ConstrainingFacet<vector<string> >::validateCFacetValueWrtParent(vector<string> val)
  { }

  namespace Types 
  {
    map<DOMString, anyType*>   anyType::_qNameToTypeMap;

    anyType::anyType(AnyTypeCreateArgs args, eAnyTypeUseCase anyTypeUseCase_):
      XPlusObject("anyType"),
      _anyTypeUseCase(anyTypeUseCase_),  
      _ownerNode(args.ownerNode),
      _ownerElem(args.ownerElem),
      _ownerDoc(args.ownerDoc),
      _fsm(NULL),
      _value(""),
      _abstract(args.abstract),
      _blockMask(args.blockMask),
      _finalMask(args.finalMask),
      _defaultValue(""),
      _isSampleCreate(args.isSampleCreate),
      _sampleValue(""),
      _isDefaultText(false)
    {
      if(_abstract == true)
      {
        ValidationException ex("Since the element's type-definition is declared abstract in the schema document, all instances of this element must use 'xsi:type' in the instance document, to indicate a derived type that is not abstract");
        if(_ownerElem)
        {
          ex.setContext("element", *_ownerElem->getNodeName());
          if(_ownerElem->getParentNode()) {
            _ownerElem->getParentNode()->removeChild(_ownerElem);  
          }
        }
        throw ex;
      }

      if(anyTypeUseCase() == ANY_SIMPLE_TYPE) {
        _contentTypeVariety = CONTENT_TYPE_VARIETY_SIMPLE;
      }
      else {
        _contentTypeVariety = CONTENT_TYPE_VARIETY_MIXED; // for anyType
      }

      if(ownerElement())
      {
        XsdFsmBasePtr fsmsAttrs[] =
        { 
                                            // ---- xml  --- //
          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xmlUriPtr, *Namespaces::s_xmlLangStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXmlLang)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xmlUriPtr, *Namespaces::s_xmlSpaceStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE,
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXmlSpace)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xmlUriPtr, *Namespaces::s_xmlBaseStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXmlBase)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xmlUriPtr, *Namespaces::s_xmlIdStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXmlId)),

                                            // ---- xsi  --- //

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xsiUriPtr, *Namespaces::s_xsiTypeStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXsiType)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xsiUriPtr, *Namespaces::s_xsiNilStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE,
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXsiNil)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xsiUriPtr, *Namespaces::s_xsiSchemaLocationStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXsiSchemaLocation)),

          new XsdFSM<DOM::Attribute *>( Particle(Namespaces::s_xsiUriPtr, *Namespaces::s_xsiNoNamespaceSchemaLocationStrPtr, 0, 1),
                                        XsdEvent::ATTRIBUTE, 
                                        new object_unary_mem_fun_t<DOM::Attribute*, anyType, FsmCbOptions>(this, &anyType::createAttributeXsiNoNamespaceSchemaLocation)),

          NULL 
        };
        XsdFsmBasePtr fsmsContent[] = { NULL };
        XsdFsmBase* contentFsm = new XsdSequenceFsmOfFSMs(fsmsContent); 
        XsdFsmBaseP elemEndFsm = new XsdFSM<void *>(Particle( ownerElement()->getNamespaceURI(), *ownerElement()->getTagName(), 1, 1),
                                                    XsdEvent::ELEMENT_END);
        
        _fsm = new AnyTypeFSM(fsmsAttrs, contentFsm, elemEndFsm);
      }
      else
      {
        XsdFsmBasePtr fsmsAttrs[] = { NULL };
        XsdFsmBasePtr fsmsContent[] = { NULL };
        XsdFsmBase* contentFsm = new XsdSequenceFsmOfFSMs(fsmsContent); 
        XsdFsmBaseP elemEndFsm = new XsdFSM<void *>(Particle(NULL, "", 1, 1), XsdEvent::ELEMENT_END);
        _fsm = new AnyTypeFSM(fsmsAttrs, contentFsm, elemEndFsm);
      }
    }

    unsigned int anyType::lengthFacet() 
    {
      TextEncoding::eTextEncoding docEncoding = TextEncoding::UTF_8;
      if(this->ownerDocument()) {
        docEncoding = ownerDocument()->encoding();
      }
      return _value.countCodePoints(docEncoding); 
    }

    void anyType::setErrorContext(XPlus::Exception& ex)
    {
      if(this->ownerElement()) {
        ex.setContext("element", *this->ownerElement()->getNodeName());
      }
    }

    TElement* anyType::ownerElement() 
    {
      return dynamic_cast<TElement *>(_ownerElem);
    }

    const TElement* anyType::ownerElement() const
    {
      return ownerElement();
    }


    void anyType::checkFixed(DOMString value) 
    {
      if(ownerElement() && ownerElement()->fixed() && (value != _defaultValue)) 
      {
        ValidationException ex("Fixed value of the node can not be changed");
        ex.setContext("fixed-value", _defaultValue);
        ex.setContext("supplied-value", value);
        throw ex;
      }
    }

    void anyType::checkContentType(DOMString value)
    {
      if( (contentTypeVariety() == CONTENT_TYPE_VARIETY_ELEMENT_ONLY) &&
          !value.matchCharSet(UTF8FNS::isSpaceChar)
        )
      {
        ostringstream err;
        err << "Character content other than whitespace is not allowed"
          " because the content type is 'element-only'";
        ValidationException ex(err.str()); 
        ex.setContext("element", *this->ownerElement()->getNodeName());
        throw ex;
      }

      if( (contentTypeVariety() == CONTENT_TYPE_VARIETY_EMPTY) &&
          !value.matchCharSet(UTF8FNS::isSpaceChar) 
          // FIXME: is space allowed for empty content????
        )
      {
        ostringstream err;
        err << "Character content other than whitespace is not allowed"
          " because the content type is 'empty'";
        ValidationException ex(err.str()); 
        ex.setContext("element", *this->ownerElement()->getNodeName());
        throw ex;
      }
    }

    void anyType::checksOnSetValue(DOMString value)
    {
      checkContentType(value);
      checkFixed(value);
    }

    void anyType::normalizeValue(DOMString& value) 
    {
    }

    void anyType::postSetValue() 
    {
    }

    // 1. sets the value (in _value)
    // 2. creates the DOM TextNode with this value if the TextNode was not 
    //    there, else sets the value in the TextNode
    void anyType::stringValue(DOMString value) 
    {
      _isDefaultText = false;
      try
      {
        createTextNodeOnSetValue(value);
        setValueFromCreatedTextNodes();
      }
      catch(XPlus::Exception& ex)
      {
        if(this->ownerElement()) 
        {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          if(this->ownerElement()->getNodeValue()) {
            ex.setContext("node-value", *this->ownerElement()->getNodeValue());
          }
        }
        throw ex;
      }
    }

    //
    // _isDefaultText is set to true only in this function
    // should be reset to false in:
    //
    //  * stringValue(...)    : expected to be called by application
    //
    //  * createTextNode(...) : called on DOM building while reading 
    //                          from input xml file
    //
    void anyType::defaultValue(DOMString value) 
    {
      _defaultValue = value;
      this->stringValue(_defaultValue);
      _isDefaultText = true;
    }

    TextNode* anyType::addTextNodeValueAtPos(DOMString text, int pos)
    {
      DOM::TextNode *txtNode = NULL;
      if(!this->ownerNode()) {
        ostringstream err;
        err << "can not set text in an ComplexType without an owner parent-element";
        throw LogicalError(err.str());
      }

      if(pos == -1) 
      {
        txtNode = this->ownerNode()->createChildTextNode(new DOMString(text));
        if(!txtNode) {
          ostringstream err;
          err << "anyType: failed to add Text Node";
          XSDException ex(err.str()); 
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
        _textNodes.push_back(txtNode);
      }
      else 
      {
        txtNode = this->ownerNode()->createChildTextNodeAt(new DOMString(text), pos);
        if(!txtNode)
        {
          ostringstream err;
          err << "anyType: failed to add Text Node";
          XSDException ex(err.str()); 
          ex.setContext("element", *this->ownerElement()->getNodeName());
          throw ex;
        }
        indexAddedTextNode(txtNode);
      }
      return txtNode;
    }

    // here pos is the position of this node among all children 
    // and not just the text nodes
    void anyType::setTextAmongChildrenAt(DOMString text, int pos)
    {
      this->addTextNodeValueAtPos(text, pos);
      setValueFromCreatedTextNodes();
    }

    void anyType::setTextEnd(DOMString text)
    {
      this->setTextAmongChildrenAt(text, -1);
      setValueFromCreatedTextNodes();
    }

    void anyType::setTextAfterNode(DOMString text, DOM::Node *refNode)
    {
      if(!this->ownerNode()) {
        ostringstream err;
        err << "can not set text in an ComplexType without an owner parent-node";
        throw LogicalError(err.str());
      }
      DOM::TextNode *txtNode = this->ownerNode()->createChildTextNodeAfterNode(new DOMString(text), refNode);
      if(!txtNode) {
        ostringstream err;
        err << "anyType: failed to add Text Node";
        throw XSDException(err.str());
      }
      indexAddedTextNode(txtNode);
      setValueFromCreatedTextNodes();
    }

    void anyType::setValueFromCreatedTextNodes()
    {
      DOMString value = "";
      for(unsigned int i=0; i<_textNodes.size(); i++) {
        value += *_textNodes.at(i)->getNodeValue();
      }
      try
      {
        normalizeValue(value);
        if(!isSampleCreate()) {
          checksOnSetValue(value);
        }
        setValue(value);
        postSetValue();
      }
      catch(XPlus::Exception& ex)
      {
        if(ownerElement()) 
        { 
          ex.setContext("element", *this->ownerElement()->getNodeName());
          if(this->ownerNode() && this->ownerNode()->getNodeType()==Node::ATTRIBUTE_NODE) {
            ex.setContext("attribute", *this->ownerNode()->getNodeName());
          }
        }
        throw ex;
      }
    }

    // creates or resizes the _textNodes to make it's size exactly one.
    // TextNode(created or existing) would have the supplied value 
    TextNode* anyType::createTextNodeOnSetValue(DOMString value)
    {
      TextNode* valueNode = NULL;
      DOMStringPtr valuePtr = new DOMString(value);
      if(_textNodes.size() == 0) 
      {
        if(this->ownerNode()) {
          valueNode = this->ownerNode()->createChildTextNode(valuePtr);
        }
        else {
          // this textNode would not get added to DOM ... heppens in following cases:
          // - SimpleTypeListTmpl::stringValue -- harmless here
          // - ...
          valueNode = new TextNode(valuePtr, this->ownerDocument(), NULL);
        }
        _textNodes.push_back(valueNode);
      }
      else if(_textNodes.size() == 1) 
      {
        valueNode = _textNodes.at(0);
        valueNode->setNodeValue(valuePtr);
      }
      else // _textNodes.size() > 1
      {
        // TODO: should this new node be added to end of DOM children ??
        // delete the textNodes beyond 1st from node's children(DOM), and set 
        // the value in the 1st node

        if(this->ownerNode())
        {
          for(unsigned int i=1; i<_textNodes.size(); i++)
          {
            this->ownerNode()->removeChild(_textNodes.at(i));
          }
        }
        List<AutoPtr<DOM::TextNode> >::iterator it = _textNodes.begin();
        _textNodes.erase(++it, _textNodes.end());

        valueNode = _textNodes.at(0);
        valueNode->setNodeValue(valuePtr);
      }

      return valueNode;
    }

    //  let's take an example:
    //  <elem>
    //    TextNode1
    //    <foo>...</foo>
    //    TextNode2
    //  </elem>
    //  
    // For an input-TextNode find the input-TextNode's position among node's
    // children(DOM), and insert the input-TextNode in anyType::_textNodes
    // at the same position.
    // eg. if in the above example TextNode2 was to be input-TextNode then
    // it should be inserted at position=1 in anyType::_textNodes
    void anyType::indexAddedTextNode(TextNode *txtNode)
    {
      unsigned int posText = txtNode->countPreviousSiblingsOfType(DOM::Node::TEXT_NODE);
      if(posText>_textNodes.size()) {
        ostringstream err;
        err << "anyType: Text Node added, though don't know where to index.";
        throw LogicalError(err.str());
      }
      List<AutoPtr<DOM::TextNode> >::iterator it = _textNodes.begin();
      for(unsigned int i=0; i<posText; ++i) {
        ++it;
      }
      _textNodes.insert(it, txtNode);
    }

    TElement* anyType::createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec)
    {
      TElement* elemNode = NULL;
      if(!localName) {
        throw XPlus::NullPointerException("createElementNS: localName is NULL");
      }

      // create the element
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
          elemNode = dynamic_cast<TElement *>(const_cast<Node*>(_fsm->fsmCreatedNode()));
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
        elemNode->createAttributeNS(const_cast<DOMString *>(attrInfo.nsUri()),
                                    const_cast<DOMString *>(attrInfo.nsPrefix()),
                                    const_cast<DOMString *>(attrInfo.localName()),
                                    const_cast<DOMString *>(attrInfo.value()) );
      }

      return elemNode;
    }


    Attribute* anyType::createAttributeNS(DOMString* nsUri, DOMString* nsPrefix, 
                                          DOMString* localName, DOMString* value)
    {
      if(!localName) {
        throw XPlus::NullPointerException("createAttributeNS: localName is NULL");
      }
      
      if(!value || (value->length() == 0) )
      {
        ostringstream err;
        err << "empty value for : " << formatNamespaceName(XsdEvent::ATTRIBUTE, nsUri, *localName);
        throw XMLSchema::ValidationException(DOMString(err.str()));
      }

      XsdEvent event(nsUri, nsPrefix, *localName, XsdEvent::ATTRIBUTE);
      if(_fsm && _fsm->processEventThrow(event))
      {
        if(_fsm->fsmCreatedNode()) 
        {
          AttributeP attr = dynamic_cast<AttributeP>(const_cast<Node*>(_fsm->fsmCreatedNode()));
          _fsm->fsmCreatedNode(NULL);
          if(attr) {
            //attr->createChildTextNode(value);
            attr->createTextNode(value);
            return attr;
          }
        }
      }

      ostringstream err;
      err << "Failed to create : " << formatNamespaceName(XsdEvent::ATTRIBUTE, nsUri, *localName) ;
      throw XMLSchema::FSMException(DOMString(err.str()));
    }


    TextNode* anyType::createTextNode(DOMString* data)
    {
      if(_isDefaultText) 
      {
				/*
        for(unsigned int i=0; i<_textNodes.size(); i++) {
          this->ownerNode()->removeChild(_textNodes.at(i));
        }
        _textNodes.clear();
        */
				_isDefaultText = false;
        
				assert(_textNodes.size() == 1);
				_textNodes.at(0)->setNodeValue(data);
        return _textNodes.at(0);
      }
			else
			{
				TextNode* valueNode = this->ownerNode()->createChildTextNode(data);
				_textNodes.push_back(valueNode);
				return valueNode;
			}
    }
        
    CDATASection* anyType::createCDATASection(DOMString* data)
    {
      CDATASection* valueNode = this->ownerNode()->createChildCDATASection(data);
      _textNodes.push_back(valueNode);
      return valueNode;
    }

    void anyType::endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
    {
      if(!localName) {
        throw XPlus::NullPointerException("endElementNS: localName is NULL");
      }

      if(_fsm->attributeFsm()) {
        _fsm->attributeFsm()->fireDefaultEvents();
      }

      setValueFromCreatedTextNodes();

      XsdEvent event(nsUri, nsPrefix, *localName, XsdEvent::ELEMENT_END);
      if(_fsm) {
        _fsm->processEventThrow(event);
      }
    }

    void anyType::endDocument()
    {
      if(_fsm)
      {
        XsdEvent event(NULL, NULL, "", XsdEvent::DOCUMENT_END);
        _fsm->processEventThrow(event);  
      }
    }

    DOM::Attribute* anyType::createDOMAttributeUnderCurrentElement( DOMString *attrName, 
                                                                    DOMString *attrNsUri, 
                                                                    DOMString *attrNsPrefix, 
                                                                    DOMString *attrValue
                                                                  )
    {
      return new DOM::Attribute( attrName, attrValue, attrNsUri, attrNsPrefix, ownerElement(), ownerDocument());
    }

    DOM::Attribute* anyType::createAttributeXmlLang(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xmlLangStrPtr, Namespaces::s_xmlUriPtr, Namespaces::s_xmlStrPtr); 
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXmlSpace(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xmlSpaceStrPtr, Namespaces::s_xmlUriPtr, Namespaces::s_xmlStrPtr); 
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXmlBase(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xmlBaseStrPtr, Namespaces::s_xmlUriPtr, Namespaces::s_xmlStrPtr); 
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXmlId(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xmlIdStrPtr, Namespaces::s_xmlUriPtr, Namespaces::s_xmlStrPtr); 
      _fsm->fsmCreatedNode(attr);
      return attr;
    }
    
    DOM::Attribute* anyType::createAttributeXsiType(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xsiTypeStrPtr, Namespaces::s_xsiUriPtr, Namespaces::s_xsiStrPtr); 
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXsiNil(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xsiNilStrPtr, Namespaces::s_xsiUriPtr, Namespaces::s_xsiStrPtr);
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXsiSchemaLocation(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xsiSchemaLocationStrPtr, Namespaces::s_xsiUriPtr, Namespaces::s_xsiStrPtr);
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    DOM::Attribute* anyType::createAttributeXsiNoNamespaceSchemaLocation(FsmCbOptions& options)
    {
      Attribute* attr = createDOMAttributeUnderCurrentElement(Namespaces::s_xsiNoNamespaceSchemaLocationStrPtr, Namespaces::s_xsiUriPtr, Namespaces::s_xsiStrPtr);
      _fsm->fsmCreatedNode(attr);
      return attr;
    }

    // in following xsi attrs fns, return value of these attrs
    const DOMString* anyType::xsiTypeValue()
    {
      if(ownerElement()) {
        return ownerElement()->getAttributeNS(Namespaces::s_xsiUriPtr, Namespaces::s_xsiTypeStrPtr);
      }
      return NULL;
    }

    bool anyType::isXsiNil()
    {
      const DOMString* pNilStr = NULL;
      if(ownerElement()) {
        pNilStr = ownerElement()->getAttributeNS(Namespaces::s_xsiUriPtr, Namespaces::s_xsiNilStrPtr);
      }
      if(!pNilStr || (*pNilStr == "false") ) {
        return false;
      }
      else if(*pNilStr == "true") {
        return true; 
      }
      else {
        ostringstream err;
        err << "Valid values for attribute {} nil are : true|false. "
          << " Got " << *pNilStr << endl;
        throw XMLSchema::ValidationException(DOMString(err.str()));
      }
    }

    const DOMString* anyType::xsiSchemaLocationValue()
    {
      if(ownerElement()) {
        return ownerElement()->getAttributeNS(Namespaces::s_xsiUriPtr, Namespaces::s_xsiSchemaLocationStrPtr);
      }
      return NULL;
    }

    const DOMString* anyType::xsiNoNamespaceSchemaLocationValue()
    {
      if(ownerElement()) {
        return ownerElement()->getAttributeNS(Namespaces::s_xsiUriPtr, Namespaces::s_xsiNoNamespaceSchemaLocationStrPtr);
      }
      return NULL;
    }


    //                                                 //
    //                     anySimpleType               //
    //                                                 //

    anySimpleType::anySimpleType(AnyTypeCreateArgs args, ePrimitiveDataType primType):
      anyType(args, ANY_SIMPLE_TYPE),
      _primitiveType(primType),
      _lengthCFacet(0),
      _minLengthCFacet(XP_UINT32_MIN),
      _maxLengthCFacet(XP_UINT32_MAX),
      _patternCFacet(".*"),
      _whiteSpaceCFacet("collapse"),
      _totalDigitsCFacet(0),
      _fractionDigitsCFacet(0),
      _allowedCFacets(CF_ALL),
      _appliedCFacets(CF_NONE),
      _maxInclusiveCFacetDateTime(primType),
      _maxExclusiveCFacetDateTime(primType),
      _minExclusiveCFacetDateTime(primType),
      _minInclusiveCFacetDateTime(primType),
      _maxInclusiveCFacetDuration(),
      _maxExclusiveCFacetDuration(),
      _minExclusiveCFacetDuration(),
      _minInclusiveCFacetDuration()
    {
      _allCFacets.push_back(&_lengthCFacet);
      _allCFacets.push_back(&_minLengthCFacet);
      _allCFacets.push_back(&_maxLengthCFacet);
      _allCFacets.push_back(&_patternCFacet);
      _allCFacets.push_back(&_whiteSpaceCFacet);
      _allCFacets.push_back(&_totalDigitsCFacet);
      _allCFacets.push_back(&_fractionDigitsCFacet);
      
      _allCFacets.push_back(&_maxInclusiveCFacetDouble);
      _allCFacets.push_back(&_maxInclusiveCFacetDuration);
      _allCFacets.push_back(&_maxInclusiveCFacetDateTime);

      _allCFacets.push_back(&_maxExclusiveCFacetDouble);
      _allCFacets.push_back(&_maxExclusiveCFacetDuration);
      _allCFacets.push_back(&_maxExclusiveCFacetDateTime);

      _allCFacets.push_back(&_minExclusiveCFacetDouble);
      _allCFacets.push_back(&_minExclusiveCFacetDuration);
      _allCFacets.push_back(&_minExclusiveCFacetDateTime);

      _allCFacets.push_back(&_minInclusiveCFacetDouble);
      _allCFacets.push_back(&_minInclusiveCFacetDuration);
      _allCFacets.push_back(&_minInclusiveCFacetDateTime);
    }

    void anySimpleType::endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
    {
      anyType::endElementNS(nsUri, nsPrefix, localName);
      if( (_textNodes.size()==0) 
          && (_primitiveType != PD_STRING)
          && (_primitiveType != PD_BASE64BINARY) 
          && (_primitiveType != PD_HEXBINARY) 
          && (_primitiveType != PD_ANYURI) 
          && (_primitiveType != PD_QNAME) 
        ) 
      {
        ostringstream err;
        err << "empty value for : " << formatNamespaceName(XsdEvent::ELEMENT_START, nsUri, *localName);
        throw XMLSchema::ValidationException(DOMString(err.str()));
      }
    }


    void anySimpleType::allowedCFacets(unsigned int x)
    {
      _allowedCFacets = x;
    }
    
    void anySimpleType::appliedCFacets(unsigned int x)
    {
      _appliedCFacets = x;
      for(unsigned int i=0; i<COUNT_CFACETS; ++i)
      {
        unsigned int t = (1<<i);
        if( _appliedCFacets & t ) {
          eConstrainingFacets facetType = static_cast<eConstrainingFacets>(t);
          getCFacet(facetType).markSet();
        }
      }
    }

    // checks if the value is acceptable to the simpleType
    bool anySimpleType::checkValue(DOMString val)
    {
      try {
        this->stringValue(val);
      }
      catch(XPlus::Exception& ex) {
        return false;
      }
      return true;
    }

    void anySimpleType::normalizeValue(DOMString& value) 
    {
      applyWhiteSpaceCFacet(value);
    }

    void anySimpleType::postSetValue() 
    {
      try
      {
        // eg.  store integer value ie string-to-int
        setTypedValue();
        if(!isSampleCreate()) {
          validateCFacets();
          applyCFacets();
        }
      }
      catch(Exception& ex)
      {
        if(ownerElement()) 
        { 
          ex.setContext("element", *this->ownerElement()->getNodeName());
          if(this->ownerNode() && this->ownerNode()->getNodeType()==Node::ATTRIBUTE_NODE) {
            ex.setContext("attribute", *this->ownerNode()->getNodeName());
          }
        }
        throw ex;
      }
    }
    
    void anySimpleType::stringValue(DOMString val) 
    {
      anyType::stringValue(val);
    }

    void anySimpleType::validateCFacetsApplicability()
    {
      // example:
      // _allowedCFacets :   00011010 => A
      // _appliedCFacets :   01010110 => B1
      // _appliedCFacets :   00010010 => B2
      // A & B1     =        00010010 => A intersection B1 
      // A & B2     =        00010010 => A intersection B2 
      // A | B1     =        01011110 => A union B1 
      // (A|B1)^A   =        01000100 => (A union B1) - A
      //                                 ie. part of B1 not in A

      // appliedCFacets violated allowedCFacets
      if((_appliedCFacets & _allowedCFacets) != _appliedCFacets)
      {
        ostringstream oss;
        oss << "Invalid facet for restriction-based derivation from"
          " a type with (" << g_primitivesStr[_primitiveType] 
          << ") as base-type-definition: "; 

        unsigned int violatedCFacets =
          ((_appliedCFacets|_allowedCFacets)^_allowedCFacets);
        for(unsigned int i=0; i<COUNT_CFACETS; ++i)
        {
          if( violatedCFacets & (1<<i) ) {
            oss << g_constrainingCFacetsStr[i] << " ";
          }
        }
        oss << endl;
        throw ValidationException(oss.str());
      }
    }

    void anySimpleType::validateCFacetsInError()
    {
      // report errors in CFacets
      //NB: these errors will be reported only when this type
      // has errors in it's CFacets and the value is set in this 
      // type using type.value(xyz) ( or elem.value(xyz) or 
      // attr.value(xyz), given elem/attr are of this type ) 
      // Reason of not throwing error without use, is that 
      // throwing exception is value() function of CFacet causes 
      // type constructor to be malformed. This causes malformed
      // element/attribute which was of this type.
      // Read Note on CFacet::value() function.
      ostringstream err;
      for(unsigned int i=0; i<_allCFacets.size(); i++)
      {
        if(!_allCFacets[i]->isInError()) {
          continue;
        }
        for(unsigned int j=0; j<_allCFacets[i]->errors().size(); j++)
        {
          if(j>0) err << endl;
          err <<  _allCFacets[i]->errors()[j];
        }
      }
      if(err.str().size()) {
        throw ValidationException(err.str());
      }

      // enumeration:
      // It is an ·error· if any member of {value} is not in the
      // ·value space· of {base type definition}.
      // This need not be checked separately because it should be 
      // taken care of when the value is set as one of the enumerations
      // and it undergoes validations against other CFacets
    }


    // minExclusive - minInclusive - maxInclusive - maxExclusive
    // conditions:
    //   minInclusive <= maxInclusive
    //   minExclusive <= maxExclusive
    //   minExclusive < maxInclusive
    //   minInclusive < maxExclusive

    void anySimpleType::boundsBasedInterFacetValidations()
    {
      // bounds facets (max,min incl/excl) apply to following 12 PrimitiveTypes
      switch(_primitiveType)
      {
        case PD_DURATION:
        case PD_DATETIME:
        case PD_TIME:
        case PD_DATE:
        case PD_GYEARMONTH:
        case PD_GMONTHDAY:
        case PD_GDAY:
        case PD_GMONTH:
        case PD_GYEAR:
        case PD_FLOAT:
        case PD_DECIMAL:
        case PD_DOUBLE:
          break;
        default:
          return;
      }

      ostringstream oss;
      XPlus::Exception ex;
      ex.setContext("primitive-type", g_primitivesStr[_primitiveType]);
      try
      {
        //   minInclusive <= maxInclusive
        if( isMinInclusiveCFacetSet() && isMaxInclusiveCFacetSet() &&
            (minInclusiveCFacet() > maxInclusiveCFacet() ) 
          )
        {
          ValidationException vex("inter-facet rule violated");
          vex.setContext("minInclusive Facet value", minInclusiveCFacet().stringValue());
          vex.setContext("maxInclusive Facet value", maxInclusiveCFacet().stringValue());
          vex.setContext("rule", "minInclusive <= maxInclusive");
          throw vex;
        }
      }
      catch(ValidationException& vex) {
        vex.appendException(ex);
        throw vex;
      }
      catch(XPlus::Exception& e) {
        ex.msg("Facets failed to compare. ");
        ex.appendException(e);
        ex.setContext("minInclusive Facet value", minInclusiveCFacet().stringValue());
        ex.setContext("maxInclusive Facet value", maxInclusiveCFacet().stringValue());
        throw ex; 
      }

      try
      {
        //   minExclusive <= maxExclusive
        if( isMinExclusiveCFacetSet() && isMaxExclusiveCFacetSet() &&
            (minExclusiveCFacet() > maxExclusiveCFacet() ) 
          )
        {
          ValidationException vex("inter-facet rule violated");
          vex.setContext("minExclusive Facet value", minExclusiveCFacet().stringValue());
          vex.setContext("maxExclusive Facet value", maxExclusiveCFacet().stringValue());
          vex.setContext("rule", "minExclusive <= maxExclusive");
          throw vex;
        }
      }
      catch(ValidationException& vex) {
        vex.appendException(ex);
        throw vex;
      }
      catch(XPlus::Exception& e) {
        ex.msg("Facets failed to compare. ");
        ex.appendException(e);
        ex.setContext("minExclusive Facet value", minExclusiveCFacet().stringValue());
        ex.setContext("maxExclusive Facet value", maxExclusiveCFacet().stringValue());
        throw ex; 
      }

      try
      {
        //   minExclusive < maxInclusive
        if( isMinExclusiveCFacetSet() && isMaxInclusiveCFacetSet() &&
            (minExclusiveCFacet() >= maxInclusiveCFacet() ) 
          )
        {
          ValidationException vex("inter-facet rule violated");
          vex.setContext("minExclusive Facet value", minExclusiveCFacet().stringValue());
          vex.setContext("maxInclusive Facet value", maxInclusiveCFacet().stringValue());
          vex.setContext("rule", "minExclusive < maxInclusive");
          throw vex;
        }
      }
      catch(ValidationException& vex) {
        vex.appendException(ex);
        throw vex;
      }
      catch(XPlus::Exception& e) {
        ex.msg("Facets failed to compare. ");
        ex.appendException(e);
        ex.setContext("minExclusive Facet value", minExclusiveCFacet().stringValue());
        ex.setContext("maxInclusive Facet value", maxInclusiveCFacet().stringValue());
        throw ex; 
      }

      try
      {
        //   minInclusive < maxExclusive
        if( isMinInclusiveCFacetSet() && isMaxExclusiveCFacetSet() &&
            (minInclusiveCFacet() > maxExclusiveCFacet() ) 
          )
        {
          ValidationException vex("inter-facet rule violated");
          vex.setContext("minInclusive Facet value", minInclusiveCFacet().stringValue());
          vex.setContext("maxExclusive Facet value", maxExclusiveCFacet().stringValue());
          vex.setContext("rule", "minInclusive < maxExclusive");
          throw vex;
        }
      }
      catch(ValidationException& vex) {
        vex.appendException(ex);
        throw vex;
      }
      catch(XPlus::Exception& e) {
        ex.msg("Facets failed to compare. ");
        ex.appendException(e);
        ex.setContext("minInclusive Facet value", minInclusiveCFacet().stringValue());
        ex.setContext("maxExclusive Facet value", maxExclusiveCFacet().stringValue());
        throw ex; 
      }
    }
    
    void anySimpleType::interCFacetValidation()
    {
      ostringstream oss;
      ValidationException ex("inter-facet rule violated");
      ex.setContext("primitive-type", g_primitivesStr[_primitiveType]);
      if( isLengthCFacetSet() && isMinLengthCFacetSet() &&
          (_lengthCFacet.value() < _minLengthCFacet.value() )
        )
      {
        ex.setContext("length Facet value", _lengthCFacet.value());
        ex.setContext("minLength Facet value", _minLengthCFacet.value());
        ex.setContext("rule", "length >= minlength");
        throw ex;
      }

      if( isLengthCFacetSet() && isMaxLengthCFacetSet() &&
          (_lengthCFacet.value() > _maxLengthCFacet.value() ) 
        )
      {
        ex.setContext("length Facet value", _lengthCFacet.value());
        ex.setContext("maxLength Facet value", _maxLengthCFacet.value());
        ex.setContext("rule", "length <= maxLength");
        throw ex;
      }

      if( isMinLengthCFacetSet() && isMinLengthCFacetSet() &&
          (_minLengthCFacet.value() > _maxLengthCFacet.value() )
        )
      {
        ex.setContext("minlength Facet value", _minLengthCFacet.value());
        ex.setContext("maxLength Facet value", _maxLengthCFacet.value());
        ex.setContext("rule", "minLength <= maxLength");
        throw ex;
      }


      if( isFractionDigitsCFacetSet() && isTotalDigitsCFacetSet() &&
          (_fractionDigitsCFacet.value() > _totalDigitsCFacet.value() ) 
        )
      {
        ex.setContext("fractionDigits Facet value", _fractionDigitsCFacet.value());
        ex.setContext("totalDigits Facet value", _totalDigitsCFacet.value());
        ex.setContext("rule", "fractionDigits <= totalDigits");
        throw ex;
      }
      
      boundsBasedInterFacetValidations();
    }

    // validation to see if applied do not violate any rules wrt. :
    // - facets applicability
    // - conflicts/violates the value-space of the base-type-definition
    // - inter-facet conflicts
    void anySimpleType::validateCFacets()
    {
      validateCFacetsApplicability();
      validateCFacetsInError();
      interCFacetValidation();
    }

    ConstrainingFacetBase& anySimpleType::getCFacet(eConstrainingFacets facetType)
    {
      switch(facetType)
      {
        case CF_LENGTH         :
          return _lengthCFacet;

        case CF_MINLENGTH      :
          return _minLengthCFacet;

        case CF_MAXLENGTH      :
          return _maxLengthCFacet;

        case CF_PATTERN        :
          return _patternCFacet;

        case CF_ENUMERATION    :
          return _enumerationCFacet;

        case CF_WHITESPACE     :
          return _whiteSpaceCFacet;

        case CF_MAXINCLUSIVE   :
          return maxInclusiveCFacet();

        case CF_MAXEXCLUSIVE   :
          return maxExclusiveCFacet();

        case CF_MINEXCLUSIVE   :
          return minExclusiveCFacet();

        case CF_MININCLUSIVE   :
          return minInclusiveCFacet();

        case CF_TOTALDIGITS    :
          return _totalDigitsCFacet;

        case CF_FRACTIONDIGITS :
          return _fractionDigitsCFacet;

        case CF_NONE           :
        case CF_ALL            :
          {
            throw ValidationException("Can't get CFacet for CF_NONE or CF_ALL");
          }
      }
    }

    OrderableCFacetAbstraction& anySimpleType::maxExclusiveCFacet()
    {
      switch(_primitiveType)
      {
        case PD_DATETIME:
        case PD_TIME:
        case PD_DATE:
        case PD_GYEARMONTH:
        case PD_GMONTHDAY:
        case PD_GDAY:
        case PD_GMONTH:
        case PD_GYEAR:
          return _maxExclusiveCFacetDateTime;
        
        case PD_DURATION:
          return _maxExclusiveCFacetDuration;

        case PD_FLOAT:
        case PD_DECIMAL:
        case PD_DOUBLE:
          return _maxExclusiveCFacetDouble;

        default:
          throw XPlus::Exception("Facet does not apply to type");
      }
    }

    OrderableCFacetAbstraction& anySimpleType::maxInclusiveCFacet()
    {
      switch(_primitiveType)
      {
        case PD_DATETIME:
        case PD_TIME:
        case PD_DATE:
        case PD_GYEARMONTH:
        case PD_GMONTHDAY:
        case PD_GDAY:
        case PD_GMONTH:
        case PD_GYEAR:
          return _maxInclusiveCFacetDateTime;
        
        case PD_DURATION:
          return _maxInclusiveCFacetDuration;

        case PD_FLOAT:
        case PD_DECIMAL:
        case PD_DOUBLE:
          return _maxInclusiveCFacetDouble;

        default:
          throw XPlus::Exception("Facet does not apply to type");
      }
    }

    OrderableCFacetAbstraction& anySimpleType::minExclusiveCFacet()
    {
      switch(_primitiveType)
      {
        case PD_DATETIME:
        case PD_TIME:
        case PD_DATE:
        case PD_GYEARMONTH:
        case PD_GMONTHDAY:
        case PD_GDAY:
        case PD_GMONTH:
        case PD_GYEAR:
          return _minExclusiveCFacetDateTime;
        
        case PD_DURATION:
          return _minExclusiveCFacetDuration;

        case PD_FLOAT:
        case PD_DECIMAL:
        case PD_DOUBLE:
          return _minExclusiveCFacetDouble;

        default:
          throw XPlus::Exception("Facet does not apply to type");
      }
    }

    OrderableCFacetAbstraction& anySimpleType::minInclusiveCFacet()
    {
      switch(_primitiveType)
      {
        case PD_DATETIME:
        case PD_TIME:
        case PD_DATE:
        case PD_GYEARMONTH:
        case PD_GMONTHDAY:
        case PD_GDAY:
        case PD_GMONTH:
        case PD_GYEAR:
          return _minInclusiveCFacetDateTime;
        
        case PD_DURATION:
          return _minInclusiveCFacetDuration;
        
        case PD_FLOAT:
        case PD_DECIMAL:
        case PD_DOUBLE:
          return _minInclusiveCFacetDouble;

        default:
          throw XPlus::Exception("Facet does not apply to type");
      }
    }


    void anySimpleType::throwFacetViolation(eConstrainingFacets facetType,
          DOMString foundFacetValue, DOMString msg)
    {
      ValidationException ex("node value violates the facet. ");
      ex.appendMsg(msg);
      ex.setContext("facet", enumToStringCFacet(facetType));
      ex.setContext("primitive-type",  g_primitivesStr[_primitiveType]);
      ex.setContext("expected facet-value",  getCFacet(facetType).stringValue());
      if(foundFacetValue != "") {
        ex.setContext("found facet-value",  foundFacetValue);
      }
      ex.setContext("node-value",  _value);
      throw ex;
    }

    void anySimpleType::applyCFacets()
    {
      if(_appliedCFacets == CF_NONE) {
        return;
      }

      //first apply whitespace facet
      if(isWhiteSpaceCFacetSet()) {
        applyWhiteSpaceCFacet(_value);
      }
      if(isLengthCFacetSet()) {
        applyLengthCFacet();
      }
      if(isMinLengthCFacetSet()) {
        applyMinLengthCFacet();
      }
      if(isMaxLengthCFacetSet()) {
        applyMaxLengthCFacet();
      }
      if(isPatternCFacetSet()) {
        applyPatternCFacet();
      }
      if(isEnumerationCFacetSet()) {
        applyEnumerationCFacet();
      }
      if(isMaxInclusiveCFacetSet()) {
        applyMaxInclusiveCFacet();
      }
      if(isMaxExclusiveCFacetSet()) {
        applyMaxExclusiveCFacet();
      }
      if(isMinInclusiveCFacetSet()) {
        applyMinInclusiveCFacet();
      }
      if(isMinExclusiveCFacetSet()) {
        applyMinExclusiveCFacet();
      }
      if(isTotalDigitsCFacetSet()) {
        applyTotalDigitsCFacet();
      }
      if(isFractionDigitsCFacetSet()) {
        applyFractionDigitsCFacet();
      }
    }
    
    void anySimpleType::applyLengthCFacet()
    {
      // length, minLength, maxLength facets allow any value if
      // the derivations have primitive-type as QName or NOTATION
      if((_primitiveType == PD_QNAME) || (_primitiveType == PD_NOTATION)) {
        return;
      }
      if(this->lengthFacet() != _lengthCFacet.value() ) {
        throwFacetViolation(CF_LENGTH, toString<long>(this->lengthFacet()));
      }
    }
    
    void anySimpleType::applyMinLengthCFacet()
    {
      // length, minLength, maxLength facets allow any value if
      // the derivations have primitive-type as QName or NOTATION
      if((_primitiveType == PD_QNAME) || (_primitiveType == PD_NOTATION)) {
        return;
      }
      if(this->lengthFacet() < _minLengthCFacet.value() ) {
        throwFacetViolation(CF_MINLENGTH, toString<long>(this->lengthFacet()));
      }
    }
    
    void anySimpleType::applyMaxLengthCFacet()
    {
      // length, minLength, maxLength facets allow any value if
      // the derivations have primitive-type as QName or NOTATION
      if((_primitiveType == PD_QNAME) || (_primitiveType == PD_NOTATION)) {
        return;
      }
      if(this->lengthFacet() > _maxLengthCFacet.value() ) {
        throwFacetViolation(CF_MAXLENGTH, toString<long>(this->lengthFacet()));
      }
    }

    void anySimpleType::applyPatternCFacet()
    {
      Poco::RegularExpression re(_patternCFacet.value());
      if(! re.match(_value, 0, 0) ) {
        throwFacetViolation(CF_PATTERN);
      }
    }

    void anySimpleType::applyEnumerationCFacet()
    {
      vector<DOMString> enums = _enumerationCFacet.value();
      for(unsigned int i=0; i < enums.size(); i++) {
        if(enums[i] ==  _value) {
          return;
        }
      }
      throwFacetViolation(CF_ENUMERATION, _value);
    }

    //
    //  preserve
    //    No normalization is done, the value is not changed (this is the
    //    behavior required by [XML 1.0 (Second Edition)] for element content) 
    //
    //  replace
    //    All occurrences of #x9 (tab), #xA (line feed) and #xD (carriage 
    //    return) are replaced with #x20 (space) 
    //
    // collapse
    //    After the processing implied by replace, contiguous sequences of 
    //    #x20's are collapsed to a single #x20, and leading and trailing #x20's
    //    are removed. 
    //
    // NB:
    // 1) whiteSpace is applicable to all ·atomic· and ·list· datatypes.
    // 2) For all ·atomic· datatypes other than string (and types ·derived· by
    //    ·restriction· from it) the value of whiteSpace is collapse and cannot
    //    be changed by a schema author; 
    // 3) For string the value of whiteSpace is
    //    preserve; for any type ·derived· by ·restriction· from string the value
    //    of whiteSpace can be any of the three legal values.
    // 4) For all datatypes ·derived· by ·list· the value of whiteSpace is collapse
    //    and cannot be changed by a schema author. 
    // 5) For all datatypes ·derived· by ·union· whiteSpace does not apply directly;
    //    however, the normalization behavior of ·union· types is controlled by the
    //    value of whiteSpace on that one of the ·memberTypes· against which the
    //    ·union· is successfully validated.
    void anySimpleType::applyWhiteSpaceCFacet(DOMString& value)
    {
      if( (_primitiveType != PD_STRING) && (_whiteSpaceCFacet.value() != "collapse") ) {
        throwFacetViolation(CF_WHITESPACE);
      }
      
      if(_whiteSpaceCFacet.value() == "preserve") {
        return;
      }
      if(_whiteSpaceCFacet.value() == "replace") {
        //replace TAB,LF,CR with space
        value.replaceCharsWithChar(UTF8FNS::is_TAB_LF_CR, 0x20);  
      }
      if(_whiteSpaceCFacet.value() == "collapse") {
        //replace TAB,LF,CR with space
        value.replaceCharsWithChar(UTF8FNS::is_TAB_LF_CR, 0x20);  
        
        //remove contiguous spaces
        value.removeContiguousChars(UTF8FNS::isWhiteSpaceChar);
        
        // trim leading and trailing spaces 
        value.trim(UTF8FNS::isWhiteSpaceChar);
      }
    }
    
    void anySimpleType::applyMaxInclusiveCFacet() {
      cout << " applyMaxInclusiveCFacet for" << _primitiveType << endl;
    }

    void anySimpleType::applyMaxExclusiveCFacet() {
    }

    void anySimpleType::applyMinInclusiveCFacet() {
      cout << " applyMinInclusiveCFacet for" << _primitiveType << endl;
    }

    void anySimpleType::applyMinExclusiveCFacet() {
    }

    void anySimpleType::applyTotalDigitsCFacet() 
    {
      unsigned int cntTotalDigits=0;
      for(unsigned int i=0; i<_value.length(); i++)
      {
        if(isdigit(_value[i])) {
          cntTotalDigits++;
        }
      }
      if(cntTotalDigits > _totalDigitsCFacet.value() ) {
        throwFacetViolation(CF_TOTALDIGITS, toString<unsigned int>(cntTotalDigits));
      }
    }

    void anySimpleType::applyFractionDigitsCFacet() 
    {
      DOMString::size_type pos = _value.find('.');
      if(pos == DOMString::npos) {
        return;
      }
      
      unsigned int cntFractionDigits=0;
      for(unsigned int i=pos; i<_value.length(); i++)
      {
        if(isdigit(_value[i])) {
          cntFractionDigits++;
        }
      }
      if(cntFractionDigits > _fractionDigitsCFacet.value() ) {
        throwFacetViolation(CF_FRACTIONDIGITS, toString<unsigned int>(cntFractionDigits));
      }
    }
    
    DOMString anySimpleType::generateSampleHexBinary(DOMString *arrSamples)
    {
      if(isLengthCFacetSet()) {
        DOMString sample = Sampler::getRandomSampleStringOfLength(_lengthCFacet.value(),
            Sampler::hexBinaryCharSet);  
        sample += sample;
        return sample;
      }
      if(isMinLengthCFacetSet() && isMaxLengthCFacetSet()) {
        DOMString sample = Sampler::getRandomSampleStringOfLengthRange(_minLengthCFacet.value(),
            _maxLengthCFacet.value(),
            Sampler::hexBinaryCharSet);  
        sample += sample;
        return sample;
      }
      else if(isMinLengthCFacetSet()) {
        DOMString sample = Sampler::getRandomSampleStringOfMinLength(_minLengthCFacet.value(),
            Sampler::hexBinaryCharSet);  
        sample += sample;
        return sample;
      }
      else if(isMaxLengthCFacetSet()) {
        DOMString sample = Sampler::getRandomSampleStringOfMaxLength(_maxLengthCFacet.value(),
            Sampler::hexBinaryCharSet);  
        sample += sample;
        return sample;
      }
      return Sampler::getRandomSample(arrSamples);
    }


    DOMString anySimpleType::generateSampleBase64Binary(DOMString *arrSamples)
    {
      if(isLengthCFacetSet()) {
        return Sampler::getRandomSampleBase64StringOfLength(_lengthCFacet.value());
      }
      if(isMinLengthCFacetSet() && isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleBase64StringOfLengthRange(_minLengthCFacet.value(), _maxLengthCFacet.value());
      }
      else if(isMinLengthCFacetSet()) {
        return Sampler::getRandomSampleBase64StringOfMinLength(_minLengthCFacet.value());
      }
      else if(isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleBase64StringOfMaxLength(_maxLengthCFacet.value());
      }
      return Sampler::getRandomSample(arrSamples);
    }

    DOMString anySimpleType::generateSampleString(DOMString *arrSamples)
    {
      if(isLengthCFacetSet()) {
        return Sampler::getRandomSampleStringOfLength(_lengthCFacet.value());
      }
      if(isMinLengthCFacetSet() && isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleStringOfLengthRange(_minLengthCFacet.value(), _maxLengthCFacet.value());
      }
      else if(isMinLengthCFacetSet()) {
        return Sampler::getRandomSampleStringOfMinLength(_minLengthCFacet.value());
      }
      else if(isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleStringOfMaxLength(_maxLengthCFacet.value());
      }
      return Sampler::getRandomSample(arrSamples);
    }

    DOMString anySimpleType::generateSampleDecimal(DOMString *arrSamples)
    {
      long long maxIncl = 1000000;
      long long minIncl = -100000;

      if(isMaxExclusiveCFacetSet()) {
        maxIncl = static_cast<long long>(_maxExclusiveCFacetDouble.value()-1); 
      }
      else if(isMaxInclusiveCFacetSet()) {
        maxIncl = static_cast<long long>(_maxInclusiveCFacetDouble.value());
      }

      if(isMinExclusiveCFacetSet()) {
        minIncl = static_cast<long long>(_minExclusiveCFacetDouble.value()+1); 
      }
      else if(isMinInclusiveCFacetSet()) {
        minIncl = static_cast<long long>(_minInclusiveCFacetDouble.value()); 
      }
      return Sampler::getRandomSampleLong(minIncl, maxIncl);
    }


    DOMString anySimpleType::generateSampleAnyURI(DOMString *arrSamples)
    {
      if(isLengthCFacetSet()) {
        return Sampler::getRandomSampleAnyURIOfLength(_lengthCFacet.value());
      }
      if(isMinLengthCFacetSet() && isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleAnyURIOfLengthRange(_minLengthCFacet.value(), _maxLengthCFacet.value());
      }
      else if(isMinLengthCFacetSet()) {
        return Sampler::getRandomSampleAnyURIOfMinLength(_minLengthCFacet.value());
      }
      else if(isMaxLengthCFacetSet()) {
        return Sampler::getRandomSampleAnyURIOfMaxLength(_maxLengthCFacet.value());
      }
      return Sampler::getRandomSample(arrSamples);
    }

    DOMString anySimpleType::generateSample(DOMString *arrSamples)
    {
      if(isEnumerationCFacetSet())
      {
        vector<DOMString> enumStrings = _enumerationCFacet.value();
        return Sampler::getRandomSample(enumStrings);
      }

      //FIXME: if fixed used fixed value
      
      switch(_primitiveType)
      {
        case PD_STRING:
          return generateSampleString(arrSamples);

        case PD_DECIMAL:
          return generateSampleDecimal(arrSamples);

        case PD_HEXBINARY:
          return generateSampleHexBinary(arrSamples);

        case PD_BASE64BINARY:
          return generateSampleBase64Binary(arrSamples);

        case PD_ANYURI:
          return generateSampleAnyURI(arrSamples);

        default:
          return Sampler::getRandomSample(arrSamples);
      }
    }

        
  }// end namespace Types

}


