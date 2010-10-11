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
