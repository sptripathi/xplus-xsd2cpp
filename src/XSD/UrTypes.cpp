// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Free Software Foundation, Inc.
// Author: Satya Prakash Tripathi
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

#include "XSD/PrimitiveTypes.h"
#include "XSD/xsdUtils.h"
#include "XSD/XSDException.h"
#include "Poco/RegularExpression.h"

extern "C" {
#include <ctype.h>
}

using namespace std;

namespace XMLSchema
{
  template<> void ConstrainingFacet<vector<string> >::validateCFacetValueWrtParent(vector<string> val)
  { }

  namespace Types {
    
    anyType::anyType(
        NodeP ownerNode,
        ElementP ownerElem,
        TDocumentP ownerDoc,
        eAnyTypeUseCase anyTypeUseCase
        ):
      _ownerNode(ownerNode),
      _ownerElem(ownerElem),
      _ownerDoc(ownerDoc),
      //_fsmCreatedNode(NULL),
      _value(""),
      _fsm(NULL),
      _valueNode(NULL),
      _fixed(false)
    {
      if(_ownerElem)
      {
        XsdFsmBaseP elemEndFsm = new XsdFSM<void *>(NSNamePairOccur(ownerElement()->getNamespaceURI(), 
              *ownerElement()->getTagName(), 1, 1), XsdFsmBase::ELEMENT_END);
        XsdFsmBasePtr ptrFsms[] = { elemEndFsm, NULL };
        _fsm = new XsdFsmOfFSMs(ptrFsms, XsdFsmOfFSMs::SEQUENCE);
      }

    }

    void anyType::setErrorContext(XPlus::Exception& ex)
    {
      if(this->ownerElement()) {
        ex.setContext("element", *this->ownerElement()->getNodeName());
      }
    }

    TElementP anyType::ownerElement() 
    {
      return dynamic_cast<TElement *>(_ownerElem);
    }

    void anyType::checkFixed(DOMString value) 
    {
      if(fixed() & (value != _value)) {
        ValidationException ex("Fixed value of the node can not be changed");
        ex.setContext("fixed-value", _value);
        ex.setContext("supplied-value", value);
        throw ex;
      }
    }

    void anyType::stringValue(DOMString value) 
    {
      try
      {
        checkFixed(value);
        setTextNodeValue(value);
        _value = value;
      }
      catch(XPlus::Exception& ex)
      {
        ex.setContext("element", *this->ownerElement()->getNodeName());
        throw ex;
      }
    }

    TextNodeP anyType::setTextNodeValue(DOMString value) 
    {
      if(this->ownerNode()) 
      {
        DOMStringPtr pStr = new DOMString(value);
        if(!_valueNode) {
          _valueNode = this->ownerNode()->createChildTextNode(pStr);
        }
        else {
          _valueNode->setNodeValue(new DOMString(value));
        }
      }
      return _valueNode;
    }


    TElement* anyType::createElementNS(DOMString* nsUri, 
        DOMString* nsPrefix, 
        DOMString* localName) 
    {
      if(!localName) {
        throw XPlus::NullPointerException("createElementNS: localName is NULL");
      }
      if(_fsm && _fsm->processEventThrow(nsUri, *localName, XsdFsmBase::ELEMENT_START))
      {
        if(_fsm->fsmCreatedNode()) 
        {
          TElement* elem = dynamic_cast<TElement *>(const_cast<Node*>(_fsm->fsmCreatedNode()));
          _fsm->fsmCreatedNode(NULL);
          return elem;
        }
      }
      ostringstream err;
      err << "Unexpected Element: " << formatNamespaceName(XsdFsmBase::ELEMENT_START, nsUri, *localName);
      throw XMLSchema::FSMException(DOMString(err.str()));
    }


    AttributeP anyType::createAttributeNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, DOMString* value)
    {
      if(!localName) {
        throw XPlus::NullPointerException("createAttributeNS: localName is NULL");
      }

      if(_fsm && _fsm->processEventThrow(nsUri, *localName, XsdFsmBase::ATTRIBUTE))
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
      err << "Unexpected : " << formatNamespaceName(XsdFsmBase::ATTRIBUTE, nsUri, *localName) ;
      throw XMLSchema::FSMException(DOMString(err.str()));
    }

    TextNodeP anyType::createTextNode(DOMString* data)
    {
      if(data) {
        stringValue(*data);
        return _valueNode;
      }
      return NULL;
    }

    void anyType::endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
    {
      if(!localName) {
        throw XPlus::NullPointerException("endElementNS: localName is NULL");
      }
      if(_fsm) {
        _fsm->processEventThrow(nsUri, *localName, XsdFsmBase::ELEMENT_END);
      }
      else 
      {
        //FIXME
        //throw XMLSchema::FSMException("Found end-of-Element of a child-element while no child-element expected");
      }
    }

    void anyType::endDocument()
    {
      if(_fsm) {
        _fsm->processEventThrow(NULL, "", XsdFsmBase::DOCUMENT_END);  
      }
    }



    //                                                 //
    //                     anySimpleType               //
    //                                                 //

    anySimpleType::anySimpleType(
        ePrimitiveDataType primType, 
        NodeP ownerNode,
        ElementP ownerElem,
        TDocumentP ownerDoc
        ):
      anyType(ownerNode, ownerElem, ownerDoc, anyType::ANY_SIMPLE_TYPE),
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
      
      /*
      _allCFacets.push_back(&_maxInclusiveCFacet);
      _allCFacets.push_back(&_maxExclusiveCFacet);
      _allCFacets.push_back(&_minExclusiveCFacet);
      _allCFacets.push_back(&_minInclusiveCFacet);
      */
    }

    void anySimpleType::endElementNS(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName)
    {
      anyType::endElementNS(nsUri, nsPrefix, localName);
      if(!_valueNode && (_primitiveType != PD_STRING)) {
        ostringstream err;
        err << "empty-value for element: " << formatNamespaceName(XsdFsmBase::ELEMENT_START, nsUri, *localName);
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

    void anySimpleType::stringValue(DOMString val) 
    {
      try
      {
        checkFixed(val);
        _value = val;
        // eg.  store integer value ie string-to-int
        setTypedValue();
        validateCFacets();
        applyCFacets();
        setTextNodeValue(_value);
      }
      catch(XPlus::Exception& ex)
      {
        if(this->ownerElement()) {
          ex.setContext("element", *this->ownerElement()->getNodeName());
          if(this->ownerElement()->getNodeValue())
            ex.setContext("node-value", *this->ownerElement()->getNodeValue());
        }
        throw ex;
      }
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


    void anySimpleType::throwFacetViolation(eConstrainingFacets facetType, string msg)
    {
      ValidationException ex("node value violates the facet. ");
      ex.appendMsg(msg);
      ex.setContext("facet", enumToStringCFacet(facetType));
      ex.setContext("primitive-type",  g_primitivesStr[_primitiveType]);
      ex.setContext("facet-value",  getCFacet(facetType).stringValue());
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
        applyWhiteSpaceCFacet();
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
        throwFacetViolation(CF_LENGTH);
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
        throwFacetViolation(CF_MINLENGTH);
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
        throwFacetViolation(CF_MAXLENGTH);
      }
    }

    void anySimpleType::applyPatternCFacet()
    {
      Poco::RegularExpression re(_patternCFacet.value());
      if(! re.match(_value) ) {
        throwFacetViolation(CF_PATTERN);
      }
    }

    void anySimpleType::applyEnumerationCFacet()
    {
      vector<string> enums = _enumerationCFacet.value();
      for(unsigned int i=0; i < enums.size(); i++) {
        if(enums[i] ==  _value) {
          return;
        }
      }
      throwFacetViolation(CF_ENUMERATION);
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
    void anySimpleType::applyWhiteSpaceCFacet()
    {
      if( (_primitiveType != PD_STRING) && (_whiteSpaceCFacet.value() != "collapse") ) {
        throwFacetViolation(CF_WHITESPACE);
      }
      
      if(_whiteSpaceCFacet.value() == "preserve") {
        return;
      }
      if(_whiteSpaceCFacet.value() == "replace") {
        //replace TAB,LF,CR with space
        _value.replaceCharsWithChar(UTF8FNS::is_TAB_LF_CR, 0x20);  
      }
      if(_whiteSpaceCFacet.value() == "collapse") {
        //replace TAB,LF,CR with space
        _value.replaceCharsWithChar(UTF8FNS::is_TAB_LF_CR, 0x20);  
        
        //remove contiguous spaces
        _value.removeContiguousChars(UTF8FNS::isWhiteSpaceChar);
        
        // trim leading and trailing spaces 
        _value.trim(UTF8FNS::isWhiteSpaceChar);
      }
    }
    
    void anySimpleType::applyMaxInclusiveCFacet() {
    }

    void anySimpleType::applyMaxExclusiveCFacet() {
    }

    void anySimpleType::applyMinInclusiveCFacet() {
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
        throwFacetViolation(CF_TOTALDIGITS);
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
        throwFacetViolation(CF_FRACTIONDIGITS);
      }
    }



    //                                                 //
    //                     anyComplexType              //
    //                                                 //

    anyComplexType::anyComplexType(
        NodeP ownerNode,
        ElementP ownerElem,
        TDocumentP ownerDoc,
        bool mixedContent
        ):
      anyType(ownerNode, ownerElem, ownerDoc, anyType::ANY_COMPLEX_TYPE),
      _mixedContent(mixedContent)
    {
    }

    TextNode* anyComplexType::createTextNode(DOMString* data)
    {
      if(data) {
        return setTextNodeValue(*data);
      }
      return NULL;
    }
    
    TextNode* anyComplexType::setTextNodeValue(DOMString value) 
    {
      return this->addTextNodeValueAtPos(value, -1);
    }

    void anyComplexType::indexAddedTextNode(TextNode *txtNode)
    {
      unsigned int posText = txtNode->countPreviousSiblingsOfType(DOM::Node::TEXT_NODE);
      if(posText>_textNodes.size()) {
        ostringstream err;
        err << "anyComplexType: Text Node added, though don't know where to index.";
        throw LogicalError(err.str());
      }
      List<DOM::TextNode *>::iterator it = _textNodes.begin();
      for(unsigned int i=0; i<posText; ++i) {
        ++it;
      }
      _textNodes.insert(it, txtNode);
    }

    TextNode* anyComplexType::addTextNodeValueAtPos(DOMString text, unsigned int pos)
    {
      DOM::TextNode *txtNode = NULL;
      if(!this->ownerNode()) {
        ostringstream err;
        err << "can not set text in an ComplexType without an owner parent-element";
        throw LogicalError(err.str());
      }

      if(!mixedContent() && !text.matchCharSet(UTF8FNS::isSpaceChar)) {
        ostringstream err;
        err << "Character content other than whitespace is not allowed"
               " because the content type is 'element-only'";
        ValidationException ex(err.str()); 
        ex.setContext("element", *this->ownerElement()->getNodeName());
        throw ex;
      }

      if(pos==-1) 
      {
        txtNode = this->ownerNode()->createChildTextNode(new DOMString(text));
        if(!txtNode) {
          ostringstream err;
          err << "anyComplexType: failed to add Text Node";
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
          err << "anyComplexType: failed to add Text Node";
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
    void anyComplexType::setTextAmongChildrenAt(DOMString text, unsigned int pos)
    {
      this->addTextNodeValueAtPos(text, pos);
    }

    void anyComplexType::setTextEnd(DOMString text)
    {
      this->setTextAmongChildrenAt(text, -1);
    }

    void anyComplexType::setTextAfterNode(DOMString text, DOM::Node *refNode)
    {
      if(!this->ownerNode()) {
        ostringstream err;
        err << "can not set text in an ComplexType without an owner parent-element";
        throw LogicalError(err.str());
      }
      DOM::TextNode *txtNode = this->ownerNode()->createChildTextNodeAfterNode(new DOMString(text), refNode);
      if(!txtNode) {
        ostringstream err;
        err << "anyComplexType: failed to add Text Node";
        throw XSDException(err.str());
      }
      indexAddedTextNode(txtNode);
    }
        
  }// end namespace Types

}


