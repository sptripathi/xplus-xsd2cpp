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
