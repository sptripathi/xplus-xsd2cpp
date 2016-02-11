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

#ifndef __XSD_SIMPLETYPELISTUNION_H__ 
#define __XSD_SIMPLETYPELISTUNION_H__

#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <list>

#include "XPlus/AutoPtr.h"
#include "XPlus/UString.h"
#include "XPlus/StringUtils.h"

#include "DOM/DOMAllInc.h"
#include "XSD/Enums.h"
#include "XSD/XSDException.h"
#include "XSD/UrTypes.h"
#include "XSD/Facets.h"
#include "XSD/Sampler.h"

using namespace std;
using namespace XPlus;

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
    class SimpleTypeUnionTmpl : public XMLSchema::Types::anySimpleType 
    {
      public:

        SimpleTypeUnionTmpl(AnyTypeCreateArgs args):
          _idxSelMember(-1),
          anySimpleType(args, PD_STRING)
      {
      }

      virtual ~SimpleTypeUnionTmpl() {}

      inline DOMString value() {
        return anySimpleType::stringValue();
      }

      bool checkValue(DOMString val)
      {
        bool valid = false;    
        for(unsigned int i=0; i<_unionMembers.size(); i++)
        {
          valid = _unionMembers.at(i)->checkValue(val);
          if(valid) {
            break;
          }
        }
        return valid;
      }

      int checkValueForIndex(DOMString val)
      {
        bool valid = false;    
        for(int i=0; i<(int)_unionMembers.size(); i++)
        {
          valid = _unionMembers.at(i)->checkValue(val);
          if(valid) {
            return i;
          }
        }
        return -1;
      }


      virtual void stringValue(DOMString val)
      {
        int idx = checkValueForIndex(val);
        if(idx == -1)
        {
          ValidationException ex("The supplied value not valid for any of the union members");
          ex.setContext("supplied value", val);
          setErrorContext(ex);
          throw ex;
        }
        _idxSelMember = idx;
        anySimpleType::stringValue(val);
      }

      virtual DOMString sampleValue() 
      {
        if(isEnumerationCFacetSet()) {
          vector<DOMString> enumStrings = _enumerationCFacet.value();
          return Sampler::getRandomSample(enumStrings);
        }

        long int idx = Sampler::nonnegativeIntegerRandom(_unionMembers.size());
        return _unionMembers.at(idx)->sampleValue();
      }

      void setValueFromCreatedTextNodes()
      {
        DOMString value = "";
        for(unsigned int i=0; i<_textNodes.size(); i++) {
          value += *_textNodes.at(i)->getNodeValue();
        }
        try
        {
          normalizeValue(value);
          int idx = checkValueForIndex(value);
          if(idx == -1) {
            ValidationException ex("The supplied value not valid for any of the union members");
            ex.setContext("supplied value", value);
            throw ex;
          }
          _idxSelMember = idx;
          _unionMembers.at(_idxSelMember)->checksOnSetValue(value);
          _value = value;
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
        
      virtual void postSetValue()
      {
        try
        {
          if(_idxSelMember != -1)
          {
            _unionMembers.at(_idxSelMember)->validateCFacets();
            _unionMembers.at(_idxSelMember)->applyCFacets();
          }
          else
          {
            ValidationException ex("Logical error while setting union member value");
            throw ex;
          }
          applyCFacets();
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


      protected:

      int _idxSelMember;
      List<AutoPtr<anySimpleType> > _unionMembers;
    };

  } // end namespace Types 
} // end namespace XMLSchema

#endif
