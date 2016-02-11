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

#ifndef __DOM_COMMON_INCLUDE__
#define __DOM_COMMON_INCLUDE__

extern "C" {
#include <string.h>  
#include "expat_external.h"
}

#include "XPlus/LList.h" 
#include "XPlus/AutoPtr.h" 
#include "XPlus/UString.h" 
using namespace XPlus;

namespace DOM
{

      /*
         Interface Names from w3c DOM-core doc:

         Attribute
         CDATASection
         CharacterData
         Comment
         Document
         DocumentFragment
         DocumentType
         DOMException
         DOMImplementation
         Element
         Entity
         EntityRef
         NamedNodeMap
         Node
         NodeList
         Notation
         ProcInstruction
         TextNode

*/ 

  class Attribute;
  class CDATASection;
  class CharacterData;
  class Comment;
  class Document;
  class DocumentFragment;
  class DocumentType;
  class DOMException;
  class DOMImplementation;
  class Element;
  class Entity;
  class EntityRef;
  class NamedNodeMap;
  class Node;
  //class NodeList;
  class Notation;
  class PI;
  class TextNode;
  class NodePredicates;
  //class DOMString;

  /* typedefs from DOM spec */
  typedef unsigned long long DOMTimeStamp;


  /* typedefs related to DOM impl */
  typedef XML_Char DOMChar;
  typedef AutoPtr<DOMChar> DOMCharPtr;
  typedef DOMChar* DOMCharP;
  
  typedef AutoPtr<CDATASection> CDATASectionPtr;
  typedef CDATASection* CDATASectionP;

  typedef AutoPtr<CharacterData> CharacterDataPtr;
  typedef CharacterData* CharacterDataP;

  typedef AutoPtr<Comment> CommentPtr;
  typedef Comment* CommentP;

  typedef AutoPtr<Document> DocumentPtr;
  typedef Document* DocumentP;

  typedef AutoPtr<DocumentFragment> DocumentFragmentPtr;
  typedef DocumentFragment* DocumentFragmentP;

  typedef AutoPtr<DocumentType> DocumentTypePtr;
  typedef DocumentType* DocumentTypeP;

  typedef AutoPtr<DOMException> DOMExceptionPtr;
  typedef DOMException* DOMExceptionP;

  typedef AutoPtr<DOMImplementation> DOMImplementationPtr;
  typedef DOMImplementation* DOMImplementationP;
  
  typedef AutoPtr<Entity> EntityPtr;
  typedef Entity* EntityP;

  typedef AutoPtr<EntityRef> EntityRefPtr;
  typedef EntityRef* EntityRefP;

  typedef AutoPtr<NamedNodeMap> NamedNodeMapPtr;
  typedef NamedNodeMap* NamedNodeMapP;
  
  typedef AutoPtr<Node> NodePtr;
  typedef Node* NodeP;
  
  typedef XPlus::LList<Node> NodeList;
  typedef NodeList* NodeListPtr;
  typedef NodeList* NodeListP;
 
  typedef AutoPtr<Attribute> AttributePtr;
  typedef Attribute* AttributeP;

  typedef AutoPtr<Element> ElementPtr;
  typedef Element* ElementP;

  typedef AutoPtr<TextNode> TextNodePtr;
  typedef TextNode* TextNodeP;

  typedef AutoPtr<Notation> NotationPtr;
  typedef Notation* NotationP;

  typedef AutoPtr<PI> PIPtr;
  typedef PI* PIP;
  
  typedef XPlus::UString DOMString;
  typedef AutoPtr<DOMString> DOMStringPtr;
  //typedef DOMString* DOMStringPtr;
  typedef DOMString* DOMStringP;

  bool matchNamespace(const DOMString* nsUri1, const  DOMString* nsUri2);
}
#endif
