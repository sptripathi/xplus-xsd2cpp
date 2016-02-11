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
