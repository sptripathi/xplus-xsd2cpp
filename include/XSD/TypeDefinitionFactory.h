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

#ifndef __XSD_TYPEDEFINITIONFACTORY_H__ 
#define __XSD_TYPEDEFINITIONFACTORY_H__

#include <map>
#include "XSD/UrTypes.h"
#include "XPlus/Exception.h"

using namespace std;
using namespace XMLSchema::Types;


namespace XSD
{
  struct StructCreateAttrThroughFsm
  {
    DOMString*    tagName;
    DOMString*    nsUri;
    DOMString*    nsPrefix;
    Element*      ownerElem;
    TDocument*    ownerDoc;
    XsdFsmBase*   fsm;
    FsmCbOptions  options;

    StructCreateAttrThroughFsm(
                              DOMString*    tagName_,
                              DOMString*    nsUri_,
                              DOMString*    nsPrefix_,
                              Element*      ownerElem_,
                              TDocument*    ownerDoc_,
                              XsdFsmBase*   fsm_,
                              FsmCbOptions  options_
                              ):
                        tagName(tagName_),
                        nsUri(nsUri_),
                        nsPrefix(nsPrefix_),
                        ownerElem(ownerElem_),
                        ownerDoc(ownerDoc_),
                        fsm(fsm_),
                        options(options_)
    {
    }
  };



  struct StructCreateElementThroughFsm
  {
    DOMString* tagName;
    DOMString* nsUri;
    DOMString* nsPrefix;
    Node*      parentNode;
    TDocument* ownerDoc;
    
    bool         abstract;
    bool         nillable;
    bool         fixed;

    XsdFsmBase*   fsm;
    FsmCbOptions options;

    // following 2 applicable only when an <element> has 
    // a @type  attribute in xsd
    DOMString actualTypeNsUri;
    DOMString actualTypeName;



    StructCreateElementThroughFsm(DOMString* tagName_,
                              DOMString* nsUri_,
                              DOMString* nsPrefix_,
                              Node*      parentNode_,
                              TDocument* ownerDoc_,
                              XsdFsmBase*   fsm_,
                              FsmCbOptions options_,
                              bool abstract_=false,
                              bool nillable_=false,
                              bool fixed_ = false,
                              DOMString actualTypeNsUri_="",
                              DOMString actualTypeName_="<unknown>"
                              ):
                        tagName(tagName_),
                        nsUri(nsUri_),
                        nsPrefix(nsPrefix_),
                        parentNode(parentNode_),
                        ownerDoc(ownerDoc_),
                        abstract(abstract_),
                        nillable(nillable_),
                        fixed(fixed_),
                        fsm(fsm_),
                        options(options_),
 			actualTypeNsUri(actualTypeNsUri_),
			actualTypeName(actualTypeName_)
      {
      }
  };


  template<typename T> XmlElement* createType(ElementCreateArgs args) 
  { 
    try {
	    XmlElement* pElt = new XmlElement(args);
      T* pT = new T(AnyTypeCreateArgs(true, pElt, pElt, args.ownerDoc, args.childBuildsTree, false,
                              Types::BOF_NONE, Types::BOF_NONE, Types::CONTENT_TYPE_VARIETY_MIXED,
                              Types::ANY_TYPE, args.suppressTypeAbstract, args.isSampleCreate));
	pElt->userObject(pT);

	return pElt;
    }
    catch(XPlus::Exception& ex) {
      cerr << "Failed to create type:" << ex.msg() << endl;
    }

    return NULL;
  }
    
  struct MapWrapper
  {
    typedef map<string, XmlElement*(*)(ElementCreateArgs args)> map_type;
   
    MapWrapper():
     _pQNameToTypeMap(NULL)
    {}

    ~MapWrapper()
    {
      delete _pQNameToTypeMap;
    }
    
    map_type * getMap() 
    {
      // FIXME: make thread safe
      if(!_pQNameToTypeMap) {
        _pQNameToTypeMap = new map_type; 
      } 
      return _pQNameToTypeMap; 
    }

    protected: 
    map_type*  _pQNameToTypeMap;
    
  };


  struct TypeDefinitionFactory 
  {
    typedef map<string, XmlElement*(*)(ElementCreateArgs args)> map_type;
    
    TypeDefinitionFactory(const string& typeName, const string& typeNsUri):
      _name(typeName),
      _nsUri(typeNsUri)
    {
    }

    static XmlElement* getTypeForQName(const string& typeName, const string& typeNsUri, ElementCreateArgs args) 
    {
      string key = createKeyForQNameToTypeMap(typeName, typeNsUri);
      map_type::iterator it = getMap()->find(key);

      bool foundType = false;
      if(it == getMap()->end())
      {
          // if no prefix for the type, look if the type exists in the default namespace of the document
          if (typeNsUri.empty())
          {
              list<DOMString>::const_iterator itUnNs = args.ownerDoc->getUnprefixedNamespaces().begin();
              for( ; itUnNs != args.ownerDoc->getUnprefixedNamespaces().end(); ++itUnNs)
              {
                  key = createKeyForQNameToTypeMap(typeName, *itUnNs);
                  it = getMap()->find(key);
                  if(it != getMap()->end())
                  {
                      foundType = true;
                      break;
                  }
              }

              if (!foundType)
              {
                  // in case the default namespace is also explicitly defined, it is only present in the list
                  // of prefixed namespaces, so we also have to look there.
                  map<DOMString, DOMString>::const_iterator itNs = args.ownerDoc->getPrefixedNamespaces().begin();
                  for( ; itNs != args.ownerDoc->getPrefixedNamespaces().end(); ++itNs)
                  {
                      key = createKeyForQNameToTypeMap(typeName, itNs->second);
                      it = getMap()->find(key);
                      if(it != getMap()->end())
                      {
                          foundType = true;
                          break;
                      }
                  }
              }
          }
      }
      else
      {
          foundType = true;
      }
      // this calls createType
      return foundType ? it->second(args) : NULL;
    }

    protected:

    // use heap as the construction order is unknown(global order fiasco)
    static map_type* getMap() 
    {
      return _map.getMap(); 
    }

    static const string createKeyForQNameToTypeMap(const string& typeName, const string& typeNsUri)
    {
      ostringstream oss;
      oss << "{" << typeNsUri << "}" << typeName;
      return oss.str();
    }

    inline string name() {
      return _name;
    }
    
    inline string nsUri() {
      return _nsUri;
    }

    string            _name;
    string            _nsUri;

    private:
    static MapWrapper  _map;
  };

  // create a templatized derivation of TypeDefinitionFactory
  template<typename T> struct TypeDefinitionFactoryTmpl : public TypeDefinitionFactory 
  { 
    TypeDefinitionFactoryTmpl(const string& typeName, const string& typeNsUri):
      TypeDefinitionFactory(typeName, typeNsUri)
    { 
      string key = createKeyForQNameToTypeMap(typeName, typeNsUri);
      getMap()->insert(make_pair(key, &createType<T>));
    }
  };

  template<typename T> struct Check_If_T_Is_anySimpleType
  {
	typedef char yes[1];
	typedef char no[2];

 	template<typename C> static yes& test(typename C::anySimplePrimitiveType*);
 	template<typename> static no& test(...);
        
        static const bool value = sizeof(test<T>(0)) == sizeof(yes);
  };

  // TPtr : class of element's type
  template<typename T> XmlElement* createElementTmpl(StructCreateElementThroughFsm& t)
  {
    if(t.ownerDoc->buildTree() || !t.fsm->fsmCreatedNode())
    {
      DOM::Node* prevSibl = NULL;
      DOM::Node* nextSibl = NULL;
      if( !t.ownerDoc->buildingFromInputStream()) 
      {
        if(t.fsm->prevSiblingNodeRunTime() ) {
          prevSibl = const_cast<Node *>(t.fsm->prevSiblingNodeRunTime());
        }
        if(t.fsm->nextSiblingNodeRunTime() ) {
          nextSibl = const_cast<Node *>(t.fsm->nextSiblingNodeRunTime());
        }
      }
      
      ElementCreateArgs args(t.tagName, t.nsUri, t.nsPrefix, t.ownerDoc, t.parentNode, prevSibl, nextSibl, t.abstract, t.nillable, t.fixed, false, t.options.isSampleCreate);
      XmlElement* node = NULL;

      //std::cout << "xsi:type = " << t.options.xsiType << std::endl;

      // if element's type is specified in instance document using xsi:type
      if(t.options.xsiType.length()>0)
      {
        DOMString instanceTypeNsUri="", instanceTypeName="";
        vector<XPlus::UString> tokens;
        t.options.xsiType.tokenize(':', tokens);
        poco_assert(tokens.size()<=2);
        if(tokens.size() == 2) 
        {
          instanceTypeNsUri = t.ownerDoc->getNsUriForNsPrefixExplicit(tokens[0]);
          instanceTypeName = tokens[1];
        }
        else {
          instanceTypeName = tokens[0];
        }
        XmlElement* pOverriddenType = TypeDefinitionFactory::getTypeForQName(instanceTypeName, instanceTypeNsUri, args);
        if(!pOverriddenType)
        {
            ostringstream oss;
            oss << "  The value of the attribute {"
                    << XPlus::Namespaces::s_xsiUri
                    << "}type inside an element, in the instance document should resolve "
                    "to a valid derivation of it's declared type in Schema document." << endl
                    << "  Type {" << instanceTypeNsUri  << "}" << instanceTypeName
                    << " is not a derivation of Type {" << t.actualTypeNsUri << "}"
                    << t.actualTypeName;
            throw XPlus::RuntimeException(oss.str());
        }

        T* myTypeCast = dynamic_cast<T*>(pOverriddenType->userObject());
        if(!myTypeCast || pOverriddenType->userObject()->typeAbstract()) 
        {
          ostringstream oss;
          oss << "  The value of the attribute {"
              << XPlus::Namespaces::s_xsiUri 
              << "}type inside an element, in the instance document should resolve " 
                  "to a valid derivation of it's declared type in Schema document." << endl 
              << "  Type {" << instanceTypeNsUri  << "}" << instanceTypeName 
              << " is not a derivation of Type {" << t.actualTypeNsUri << "}"
              << t.actualTypeName;
          throw XPlus::RuntimeException(oss.str());
        }

	node = pOverriddenType;
      }
      else
      {
        node = new XmlElement(args);
        if (t.actualTypeName != "anySimpleType")
        {
	   T* ptr = new T(AnyTypeCreateArgs(true, node, node, args.ownerDoc, args.childBuildsTree, false,
		                      Types::BOF_NONE, Types::BOF_NONE, Types::CONTENT_TYPE_VARIETY_MIXED,
		                      Types::ANY_TYPE, args.suppressTypeAbstract, args.isSampleCreate));
	   node->userObject(ptr);
        }
        else
        {
           XMLSchema::Types::bt_string* ptr = new XMLSchema::Types::bt_string(AnyTypeCreateArgs(true, node, node, args.ownerDoc, args.childBuildsTree, false,
		                      Types::BOF_NONE, Types::BOF_NONE, Types::CONTENT_TYPE_VARIETY_MIXED,
		                      Types::ANY_TYPE, args.suppressTypeAbstract, args.isSampleCreate));
	   node->userObject(ptr);
        }
      }
      
      if(t.options.xsiNil == "true")
      {
        if(t.nillable) {
          node->userObject()->fsm()->contentFsm()->nilled(true);
        }
        else 
        {
          ostringstream ossElemNS;
          if(t.nsUri) ossElemNS << "{" << *t.nsUri << "} "; 
          ossElemNS << *t.tagName;

          ostringstream oss;
          oss << " The element can not be nilled because it is not declared nillable in the schema";  
          XPlus::RuntimeException ex(oss.str());
          ex.setContext("element", ossElemNS.str());  
          throw ex;        
        }
      }
      
      t.fsm->fsmCreatedNode(node);
      return node;
    }
    else {
      return dynamic_cast<XmlElement*>(const_cast<Node*>(t.fsm->fsmCreatedNode()));
    }
  }

  // T :   attribute's class
  template<typename T> T* createAttributeTmpl(StructCreateAttrThroughFsm t)
  {
    if(t.ownerDoc->buildTree() || ! t.fsm->fsmCreatedNode() || t.options.isDefaultCreate)
    {
      AttributeCreateArgs args(t.tagName, t.nsUri, NULL, t.ownerElem, t.ownerDoc, NULL, t.options.isSampleCreate);
      AutoPtr<T> node = new T(args);
      t.fsm->fsmCreatedNode(node);
      return node;
    }
    else {
      return dynamic_cast<T*>(const_cast<Node*>(t.fsm->fsmCreatedNode()));
    }
  }

  
}

#endif
