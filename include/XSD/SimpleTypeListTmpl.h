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
            vector<XPlus::UString> tokens;
            val.tokenize(' ', tokens);
            for(unsigned int i=0; i<tokens.size(); i++)
            {
              AnyTypeCreateArgs args;
              T t(args);
              t.stringValue(tokens[i]);
              _listValues.push_back(t);
            }
            
            anySimpleType::stringValue(val);
          }

          inline DOMString stringValue() {
            return anySimpleType::stringValue();
          }

          inline virtual unsigned int lengthFacet() {
            return _listValues.size(); 
          }

          list<T> listValues() {
            return _listValues;
          }

        protected:

          list<T>         _listValues;
      };

  } // end namespace Types 
} // end namespace XMLSchema

#endif
