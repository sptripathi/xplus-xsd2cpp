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

#ifndef __XSD_SIMPLETYPELISTTMPL_H__ 
#define __XSD_SIMPLETYPELISTTMPL_H__

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
    template<class T>
      class SimpleTypeListTmpl : public XMLSchema::Types::anySimpleType 
      {
        public:

          SimpleTypeListTmpl(AnyTypeCreateArgs args):
            anySimpleType(args, PD_STRING)
          {
          }

          virtual ~SimpleTypeListTmpl() {}

          void stringValue(DOMString val)
          {
            //setValue(val);
            anySimpleType::stringValue(val);
          }

          inline virtual DOMString stringValue() {
            return anySimpleType::stringValue();
          }

#define MAX_LIST_CNT_SAMPLE 10
          virtual DOMString sampleValue() 
          {
            int minLen = 0, maxLen = MAX_LIST_CNT_SAMPLE;
            int cnt = Sampler::integerRandomInRange(1,MAX_LIST_CNT_SAMPLE+1);
            if(isEnumerationCFacetSet()) {
              vector<DOMString> enumStrings = _enumerationCFacet.value();
              return Sampler::getRandomSample(enumStrings);
            }
            if(isLengthCFacetSet()) {
              cnt = _lengthCFacet.value();
            }
            else if(isMinLengthCFacetSet() || isMaxLengthCFacetSet())
            {
              if(isMinLengthCFacetSet()) {
                minLen = _minLengthCFacet.value();
              }
              if(isMaxLengthCFacetSet()) {
                maxLen = _maxLengthCFacet.value();
              }
              cnt = Sampler::integerRandomInRange(minLen, maxLen+1);
            }

            AnyTypeCreateArgs args;
            args.isSampleCreate = true; 
            T t(args);

            DOMString sampleListStr;
            for(int i=0; i<cnt; i++)
            {
              if(i != 0) {
                sampleListStr += " ";
              }
              sampleListStr += t.sampleValue();
            }
            return sampleListStr;
          }

          inline virtual unsigned int lengthFacet() {
            return _listValues.size(); 
          }

          list<T> listValues() {
            return _listValues;
          }

        protected:
        
          virtual void setValue(DOMString val) 
          {
            vector<XPlus::UString> tokens;
            val.tokenize(' ', tokens);
            for(unsigned int i=0; i<tokens.size(); i++)
            {
              AnyTypeCreateArgs args;
              args.isSampleCreate = _isSampleCreate; 
              T t(args);
              t.stringValue(tokens[i]);
              _listValues.push_back(t);
            }

            _value = val;
          }

          list<T>         _listValues;
      };

  } // end namespace Types 
} // end namespace XMLSchema

#endif
