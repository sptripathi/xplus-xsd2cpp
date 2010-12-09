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

#ifndef __XSD_URTYPES_H__ 
#define __XSD_URTYPES_H__

#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <list>

#include "XPlus/AutoPtr.h"
#include "XPlus/StringUtils.h"

#include "DOM/DOMAllInc.h"
#include "XSD/Enums.h"
#include "XSD/XSDException.h"
#include "XSD/XSDFSM.h"
#include "XSD/Facets.h"

using namespace std;
using namespace XPlus;
using namespace FSM;


namespace XMLSchema 
{
  //fwd-declarations
  class TElement;
  class TDocument;
  typedef AutoPtr<TElement> TElementPtr;
  typedef AutoPtr<TDocument> TDocumentPtr;
  typedef TElement* TElementP;
  typedef TDocument* TDocumentP;

  namespace Types 
  {

    //                                                          //
    //                     anyType                              //
    //                                                          //

    class anyType   : public virtual XPlus::XPlusObject 
    {
      public:

        enum eContentTypeVariety {
          CONTENT_TYPE_VARIETY_EMPTY,
          CONTENT_TYPE_VARIETY_SIMPLE,
          CONTENT_TYPE_VARIETY_ELEMENT_ONLY,
          CONTENT_TYPE_VARIETY_MIXED
        };

        enum eAnyTypeUseCase {
          ANY_TYPE,
          ANY_SIMPLE_TYPE
        };

        anyType(
            NodeP ownerNode= NULL,
            ElementP ownerElem= NULL,
            TDocumentP ownerDoc= NULL,
            eAnyTypeUseCase anyTypeUseCase = ANY_TYPE
            );

        virtual ~anyType() {}

        inline virtual NodeP ownerNode() {
          return _ownerNode;
        }
        virtual TElement* ownerElement();
        virtual const TElement* ownerElement() const;
        inline virtual TDocumentP ownerDocument() {
          return _ownerDoc;
        }

        virtual TElement* createElementWithAttributes(DOMString* nsUri, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec);
        virtual AttributeP createAttributeNS(DOMString* namespaceURI,
            DOMString* nsPrefix, DOMString* localName, DOMString* value);
        virtual void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName);
        virtual TextNodeP createTextNode(DOMString* data);
        virtual void endDocument();

        virtual void stringValue(DOMString value); 
        virtual inline DOMString stringValue() {
          return _value;
        }

        virtual bool fixed() {
          return _fixed;
        }
        virtual void fixed(bool b) {
          // TODO: verify that fixed can not be set for non-simpletype
          _fixed = b;
        }

        inline void contentTypeVariety(eContentTypeVariety variety) {
          _contentTypeVariety = variety;
        }
        inline eContentTypeVariety contentTypeVariety() const {
          return _contentTypeVariety;
        }

        inline eAnyTypeUseCase anyTypeUseCase() {
          return _anyTypeUseCase;
        }

        inline unsigned int countText() {
          return _textNodes.size();
        }
        inline DOMString getTextAt(int pos) {
          return *_textNodes.at(pos)->getData();
        }
        // edit existing-text at a position( position among text
        // inside anyComplexType)
        void replaceTextAt(DOMString text, int pos) {
          _textNodes.at(pos)->setNodeValue(new DOMString(text));
        }
        // pos: position among all nodes inside anyComplexType
        void setTextAmongChildrenAt(DOMString text, int pos);
        void setTextEnd(DOMString text);
        void setTextAfterNode(DOMString text, DOM::Node *refNode);

        //debug
        void printTextNodes() 
        {
          List<TextNode *>::iterator it = _textNodes.begin();
          unsigned int i=0;
          for(; it != _textNodes.end(); ++it, ++i) {
            cout << "text[" << i << "] = [" << *((*it)->getData()) << "]" << endl;
          }
        }
        

        //FIXME
        //NB: returns lenth as used in CFacets:
        // eg in string it's number of code-points
        // For derived types, this function should be
        // overriden if needed a different behaviour
        inline virtual unsigned int lengthFacet() {
          return _value.countCodePoints(); 
        }
    
        // NB: xsi attributes's values are not the values from Schema Doc.
        // All the xsi attributes appear in instance doc, and their values are
        // reported as seen in the instance doc.
        const DOMString* xsiTypeValue();
        bool isXsiNil();
        const DOMString* xsiSchemaLocationValue();
        const DOMString* xsiNoNamespaceSchemaLocationValue();

        inline AnyTypeFSM* fsm() {
          return _fsm;
        }
        inline void replaceFsm(AnyTypeFSM* fsm) {
          _fsm = fsm;
        }

      protected:


        //
        //                 MEMBER FUNCTIONS 
        //
        void setErrorContext(XPlus::Exception& ex);
        virtual TextNodeP setTextNodeValue(DOMString value); 
        void indexAddedTextNode(TextNode *txtNode);
        TextNode* addTextNodeValueAtPos(DOMString value, int pos);
        void checksOnSetValue(DOMString value);
        void checkFixed(DOMString value);

        DOM::Attribute* createDOMAttributeUnderCurrentElement(DOMString *attrName, DOMString *attrNsUri=NULL, DOMString *attrNsPrefix=NULL, DOMString *attrValue=NULL);
        DOM::Attribute* createAttributeXsiType(FsmCbOptions options);
        DOM::Attribute* createAttributeXsiNil(FsmCbOptions options);
        DOM::Attribute* createAttributeXsiSchemaLocation(FsmCbOptions options);
        DOM::Attribute* createAttributeXsiNoNamespaceSchemaLocation(FsmCbOptions options);

        /*
        void setTypeQName(DOMString name, DOMStringPtr pNsStr=NULL);
        static anyType* getTypeForQName(DOMString name, DOMStringPtr pNsStr=NULL);
        static DOMString createKeyForQNameToTypeMap(DOMString name, DOMStringPtr pNsStr);
        */

        //
        //                 MEMBER VARIABLES 
        //

        eAnyTypeUseCase                 _anyTypeUseCase;
        eContentTypeVariety             _contentTypeVariety;
        bool                            _fixed;
        
        // in case of anyType and derivatives ownerElement() is same
        // Node as ownerNode(). However in case of element ownerElement()
        // is element itself(this pointer)
        Element*                        _ownerElem;
        // Node(Element or Attribute) which holds value of my type
        // eg. <element name="elem1" type="T">
        // T's ownerNode is elem1 Node
        Node*                           _ownerNode;
        TDocument*                      _ownerDoc;
        AnyTypeFSMPtr                   _fsm;

        DOMString                       _value;
        List<TextNode* >                _textNodes; 

        static std::map<DOMString, anyType*>   _qNameToTypeMap;
    };


    //                                                      //
    //                     anySimpleType                    // 
    //                                                      //



    // CF_ALL(0xFFF=4095) is to set all 12 bits so as to enable all facets
    // at the level of anySimpleType
    class anySimpleType : public anyType
    {
      public:
        anySimpleType(
            ePrimitiveDataType primType, 
            NodeP ownerNode= NULL,
            ElementP ownerElem= NULL,
            TDocumentP ownerDoc= NULL
            );

        virtual ~anySimpleType() {}
        
        bool checkValue(DOMString val);
        virtual void stringValue(DOMString value); 
        virtual inline DOMString stringValue() {
          return _value;
        }
        
        // NB:
        // The value-as-string is stored for every type(anyType and 
        // all derivations). However, additionally need to store 
        // value-as-type in those derivations, whereever there is a
        // notion of ADT.
        // The overriding impl should do string-to-type conversion
        virtual void setTypedValue() { }
        
        virtual void applyLengthCFacet();
        virtual void applyMinLengthCFacet();
        virtual void applyMaxLengthCFacet();
        virtual void applyPatternCFacet();
        virtual void applyEnumerationCFacet();
        virtual void applyWhiteSpaceCFacet();
        virtual void applyMaxInclusiveCFacet();
        virtual void applyMaxExclusiveCFacet();
        virtual void applyMinInclusiveCFacet();
        virtual void applyMinExclusiveCFacet();
        virtual void applyTotalDigitsCFacet();
        virtual void applyFractionDigitsCFacet();

        //impl
        void applyMaxInclExclCFacetHelper(BuitinTypesUnion& btUnion, bool inclusive=false);
        void applyMinInclExclCFacetHelper(BuitinTypesUnion& btUnion, bool inclusive=false);

        inline bool isWhiteSpaceCFacetSet() {
          return (CF_WHITESPACE == (_appliedCFacets & CF_WHITESPACE));
        }
      
        inline bool isLengthCFacetSet() {
          return (CF_LENGTH == (_appliedCFacets & CF_LENGTH));
        }

        inline bool isMinLengthCFacetSet() {
          return (CF_MINLENGTH == (_appliedCFacets & CF_MINLENGTH));
        }

        inline bool isMaxLengthCFacetSet() {
          return (CF_MAXLENGTH == (_appliedCFacets & CF_MAXLENGTH));
        }

        inline bool isPatternCFacetSet() {
          return (CF_PATTERN == (_appliedCFacets & CF_PATTERN));
        }

        inline bool isEnumerationCFacetSet() {
          return (CF_ENUMERATION == (_appliedCFacets & CF_ENUMERATION));
        }

        inline bool isMaxInclusiveCFacetSet() {
          return (CF_MAXINCLUSIVE == (_appliedCFacets & CF_MAXINCLUSIVE));
        }

        inline bool isMaxExclusiveCFacetSet() {
          return (CF_MAXEXCLUSIVE == (_appliedCFacets & CF_MAXEXCLUSIVE));
        }

        inline bool isMinInclusiveCFacetSet() {
          return (CF_MININCLUSIVE == (_appliedCFacets & CF_MININCLUSIVE));
        }
          
        inline bool isMinExclusiveCFacetSet() {
          return (CF_MINEXCLUSIVE == (_appliedCFacets & CF_MINEXCLUSIVE));
        }

        inline bool isTotalDigitsCFacetSet() {
          return (CF_TOTALDIGITS == (_appliedCFacets & CF_TOTALDIGITS));
        }

        inline bool isFractionDigitsCFacetSet() {
          return (CF_FRACTIONDIGITS == (_appliedCFacets & CF_FRACTIONDIGITS));
        }

        inline unsigned int allowedCFacets() {
          return _allowedCFacets;
        }
        void allowedCFacets(unsigned int x);

        inline unsigned int appliedCFacets() {
          return _appliedCFacets;
        }
        void appliedCFacets(unsigned int x);

        OrderableCFacetAbstraction& maxExclusiveCFacet();
        OrderableCFacetAbstraction& maxInclusiveCFacet();
        OrderableCFacetAbstraction& minExclusiveCFacet();
        OrderableCFacetAbstraction& minInclusiveCFacet();


      protected:
        
        virtual void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName);

        void validateCFacets();
        void validateCFacetsApplicability();
        void validateCFacetsInError();
        void interCFacetValidation();

        virtual void applyCFacets();
        ConstrainingFacetBase& getCFacet(eConstrainingFacets facetType);
        void throwFacetViolation(eConstrainingFacets facetType, string msg="");
        
        ePrimitiveDataType   _primitiveType;

        //
        //   Constraining Facets, applicable in derivations depending on
        //   the value of the bitmask "_appliedCFacets"
        //

        LengthCFacet                    _lengthCFacet;
        MinLengthCFacet                 _minLengthCFacet;
        MaxLengthCFacet                 _maxLengthCFacet;
        PatternCFacet                   _patternCFacet;
        EnumerationCFacet               _enumerationCFacet;
        WhiteSpaceCFacet                _whiteSpaceCFacet;
        TotalDigitsCFacet               _totalDigitsCFacet;
        FractionDigitsCFacet            _fractionDigitsCFacet;

        // Facets viz. (minInclusive, minExclusive, maxInclusive, 
        // maxExclusive, totalDigits, fractionDigits) applicable 
        // only to following primitive types:
        // float, double, decimal, 
        // duration,  dateTime, time, date,
        // gYearMonth, gYear, gMonthDay, gDay, gMonth


        // double
        MaxInclusiveCFacetDouble        _maxInclusiveCFacetDouble;
        MaxExclusiveCFacetDouble        _maxExclusiveCFacetDouble;
        MinExclusiveCFacetDouble        _minExclusiveCFacetDouble;
        MinInclusiveCFacetDouble        _minInclusiveCFacetDouble;

        // DateTime
        MaxInclusiveCFacetDateTime      _maxInclusiveCFacetDateTime;
        MaxExclusiveCFacetDateTime      _maxExclusiveCFacetDateTime;
        MinExclusiveCFacetDateTime      _minExclusiveCFacetDateTime;
        MinInclusiveCFacetDateTime      _minInclusiveCFacetDateTime;

        // Duration
        MaxInclusiveCFacetDuration      _maxInclusiveCFacetDuration;
        MaxExclusiveCFacetDuration      _maxExclusiveCFacetDuration;
        MinExclusiveCFacetDuration      _minExclusiveCFacetDuration;
        MinInclusiveCFacetDuration      _minInclusiveCFacetDuration;

        vector<ConstrainingFacetBase*> _allCFacets;

      private:
    
        void boundsBasedInterFacetValidations();

        // bitmasks of eConstrainingFacets
        unsigned int         _allowedCFacets;
        unsigned int         _appliedCFacets; 

    };


#if 0
    //                                                      //
    //                     anyComplexType                   // 
    //                                                      //
    class anyComplexType : public anyType
    {
      public:
        anyComplexType(
            NodeP ownerNode= NULL,
            ElementP ownerElem= NULL,
            TDocumentP ownerDoc= NULL,
            bool mixedContent = false
            );

        virtual ~anyComplexType() {}

        inline bool mixedContent() {
          return _mixedContent; 
        }
        inline void mixedContent(bool b) {
          _mixedContent = b; 
        }

        inline unsigned int countText() {
          return _textNodes.size();
        }

        inline DOMString getTextAt(unsigned int pos) {
          return *_textNodes.at(pos)->getData();
        }

        // edit existing-text at a position( position among text
        // inside anyComplexType)
        void replaceTextAt(DOMString text, unsigned int pos) {
          _textNodes.at(pos)->setNodeValue(new DOMString(text));
        }
        
        // pos: position among all nodes inside anyComplexType
        void setTextAmongChildrenAt(DOMString text, unsigned int pos);

        void setTextEnd(DOMString text);
        void setTextAfterNode(DOMString text, DOM::Node *refNode);

        //debug
        void printTextNodes() 
        {
          List<TextNode *>::iterator it = _textNodes.begin();
          unsigned int i=0;
          for(; it != _textNodes.end(); ++it, ++i) {
            cout << "text[" << i << "] = [" << *((*it)->getData()) << "]" << endl;
          }
        }

      protected:
        // anyType interface functions
        virtual TextNode* createTextNode(DOMString* data);
        virtual TextNode* setTextNodeValue(DOMString value); 
    
      private:  
        void indexAddedTextNode(TextNode *txtNode);
        TextNode* addTextNodeValueAtPos(DOMString value, unsigned int pos);

        List<TextNode* >    _textNodes; 

        bool                _mixedContent;
    };
#endif

  } // end namespace Types 
} // end namespace XMLSchema

#endif
