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
      class SimpleTypeUnionTmpl : public XMLSchema::Types::anySimpleType 
      {
        public:

          SimpleTypeUnionTmpl(
              NodeP ownerNode,
              ElementP ownerElem,
              TDocumentP ownerDoc
              ):
            anySimpleType(PD_STRING, ownerNode, ownerElem, ownerDoc)
          {
          }

          virtual ~SimpleTypeUnionTmpl() {}

          void value(DOMString val)
          {

            //_value = val;

            //TODO: how facets would be applied. eg whiteSpace facet
            vector<XPlus::UString> tokens;
            val.tokenize(' ', tokens);
            for(unsigned int i=0; i<tokens.size(); i++)
            {
              T t;
              t.value(tokens[i]);
              _listValues.push_back(t);
            }
            //setTextNodeValue(_value);
            
            anySimpleType::value(val);
          }

          // TODO: why this functions is needed
          inline DOMString value() {
            return anySimpleType::value();
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
