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

#ifndef __DOCUMENT_H__
#define __DOCUMENT_H__

#include <iostream>
#include <list>

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"
#include "DOM/XmlDecl.h"
#include "DOM/CDATASection.h"
#include "DOM/DocumentType.h"
#include "DOM/DOMImplementation.h"
#include "DOM/Element.h"

namespace DOM
{
  class Document : public Node
  {
    protected:  
      // DOM spec
      DocumentTypePtr       _doctype;
      DOMImplementationPtr  _implementation;

      // impl need
      std::map<DOMString, DOMString>  _prefixedNamespaces;
      std::list<DOMString>            _unprefixedNamepspaces;
      bool                        _attributeDefaultQualified;
      bool                        _elementDefaultQualified;

      ElementP                  _currentElement;
      bool                        _stateful;
      bool                        _buildingFromInputStream;
      bool                        _prettyPrint;

      // prolog properties, logically NOT part of Document
      XmlDecl                     _xmlDecl;

    public:

      Document(DocumentType*       doctype=NULL,
          DOMImplementation*  implementation=NULL
          );

      virtual ~Document() {}

      inline virtual const DocumentType* getDocType() const {
        return _doctype;
      }

      inline virtual const DOMImplementation* getImplementation() const {
        return _implementation;
      }

     virtual DocumentType* createDocumentType(
        const DOMString* name,
        NamedNodeMap    entities,
        NamedNodeMap    notations,
        const DOMString*      publicId,
        const DOMString*      systemId,
        const DOMString*      internalSubset);

      virtual ElementP createElement(DOMString* tagName); // throws();
      virtual DocumentFragment* createDocumentFragment();
      virtual TextNode* createTextNode(DOMString* data);
      virtual CDATASection* createCDATASection(DOMString* data);
      virtual Comment* createComment(DOMString* data);
      virtual PI* createProcessingInstruction(DOMString* target,
          DOMString* data); // throws();
      virtual AttributeP createAttribute(DOMString* name); //  throws();
      virtual EntityRef* createEntityReference(DOMString* name); //  throws();
      virtual NodeList* getElementsByTagName(DOMString* tagname);

      // Introduced in DOM Level 2:
      virtual Node* importNode(Node* importedNode, bool deep); // throws();
      virtual ElementP createElementNS(DOMString* namespaceURI,
          DOMString* qualifiedName); //  throws();

      virtual AttributeP createAttributeNS(DOMString* namespaceURI,
          DOMString* qualifiedName); 
      virtual AttributeP createAttributeNS(DOMString* nsUri, DOMString* nsPrefix,
          DOMString* localName, DOMString* value);
      virtual NodeList* getElementsByTagNameNS(DOMString* namespaceURI,
          DOMString* localName);
      virtual ElementP getElementById(DOMString* elementId);
      virtual ElementP getDocumentElement() ;
      virtual const Element* getDocumentElement() const;

      //impl apis
      virtual void startDocument();
      virtual void endDocument();
      
      virtual Element* createElementWithAttributes(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName, vector<AttributeInfo>& attrVec);

      virtual Element* createElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName);
      virtual void endElementNS(DOMString* nsURI, DOMString* nsPrefix, DOMString* localName);
      virtual inline void attributeDefaultQualified(bool b) {
        _attributeDefaultQualified = b;
      }
      virtual inline bool attributeDefaultQualified() const {
        return _attributeDefaultQualified;
      }
      virtual inline void elementDefaultQualified(bool b) {
        _elementDefaultQualified = b;
      }
      virtual inline bool elementDefaultQualified() const {
        return _elementDefaultQualified;
      }

      virtual inline void setCurrentElement(ElementP currentElem) {
        _currentElement = currentElem;
      }
      virtual inline ElementP getCurrentElement() {
        return _currentElement;
      }
      virtual inline void stateful(bool b) {
        _stateful = b;
      }
      virtual inline bool stateful() {
        return _stateful;
      }

      inline bool buildingFromInputStream() {
        return _buildingFromInputStream;
      }

      inline void prettyPrint(bool b) {
        _prettyPrint = b;
      }
      inline bool prettyPrint() const {
        return _prettyPrint;
      }

      bool isPrefixTaken(DOMString nsPrefixStr) const;
      void addPrefixedNamespace(DOMString nsPrefixStr, DOMString nsUriStr);
      void addUnprefixedNamespace(DOMString nsUriStr); 
      void registerNsPrefixNsUri(const DOMString* nsPrefix, const DOMString* nsUri);
      const DOMString getNsUriForNsPrefixExplicit(const DOMString nsPrefix) const;
      const DOMString getNsPrefixForNsUriExplicit(const DOMString nsUri) const;
      const DOMString getNsPrefixForNsUriImplicit(const DOMString nsUriStr) const;
      DOMString* getDocumentElementNsUri() ;
      const DOMString* getDocumentElementNsUri() const;
      inline const map<DOMString, DOMString>& getPrefixedNamespaces() const {
        return _prefixedNamespaces; 
      }
      inline const list<DOMString>& getUnprefixedNamespaces() const 
      {
        return _unprefixedNamepspaces; 
      }

      //FIXME: make this pvt fn later, and make DOMParser a friend
      void xmlDecl(XmlDecl xmlDecl) {
        _xmlDecl = xmlDecl;
      }
      const XmlDecl& xmlDecl() const{
        return _xmlDecl;
      }

      inline eXmlVersion version() const {
        return _xmlDecl.version(); 
      }
      inline string versionString() const {
        return _xmlDecl.versionString(); 
      }
      inline void version(eXmlVersion versionEnum) {
        _xmlDecl.version(versionEnum);
      }

      inline eStandalone standalone() const {
        return _xmlDecl.standalone(); 
      }
      inline string standaloneString() const {
        return _xmlDecl.standaloneString(); 
      }
      inline void standalone(eStandalone standaloneEnum) {
        _xmlDecl.standalone(standaloneEnum);
      }

      inline TextEncoding::eTextEncoding encoding() const {
        return _xmlDecl.encoding(); 
      }
      inline string encodingString() const {
        return _xmlDecl.encodingString(); 
      }
      inline void encoding(TextEncoding::eTextEncoding encEnum) {
        _xmlDecl.encoding(encEnum);
      }
  };

}

#endif

