// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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

#include <string>
#include <iostream>
#include <fstream>
#include <vector>

#include "DOM/DOMParser.h"
#include "DOM/Stream.h"
#include "DOM/DOMException.h"

using namespace std;

//#define _DOM_DBG 1

/*
   parentNode of type Node, readonly
    The parent of this node. All nodes, except Attr, Document, DocumentFragment, Entity, and Notation may have a parent. However, if a node has just been created and not yet added to the tree, or if it has been removed from the tree, this is null.
    
 */

void DOMParser::onDocumentStart(void *userData)
{
#ifdef _DOM_DBG
  cout << "onDocumentStart" << endl;
#endif
  _docNode->startDocument();
}

void DOMParser::onDocumentEnd(void *userData)
{
#ifdef _DOM_DBG
  cout << "onDocumentEnd" << endl;
#endif
  _docNode->endDocument();
}

void DOMParser::onXmlDecl(void            *userData,
                 const DOMString  *version,
                 const DOMString  *encoding,
                 int             standalone)
{
  XmlDecl xmlDecl(version, encoding, standalone);
  //FIXME : this may not be the right place
  _docNode->xmlDecl(xmlDecl);
}

void DOMParser::onElementStart(void *userData, NodeNSTriplet nsTriplet, vector<AttributeInfo> attrVec)
{
#ifdef _DOM_DBG
  cout << "onElementStart: element:"
    << nsTriplet.toString()
    << endl;
#endif

  // the strategy is to construct element along with attribute info, so that if 
  // needed the elemnt can take advantage of the attributes while constructing.
  // The advantage  of such an approach, becomes more obvious in DOM derivations
  // in XSD model where attributes such xsi:type dictate the way the element has
  // to be constructed

#if 0
  Node* elemNode = _docNode->createElementNS(
      const_cast<DOMString *>(nsTriplet.nsUri()),
      const_cast<DOMString *>(nsTriplet.nsPrefix()),
      const_cast<DOMString *>(nsTriplet.localName()) );

  if(!elemNode) {
    ostringstream err;
    err << "failed to create element ["  << *nsTriplet.localName() << "] ";
    throw DOMException(err.str());
  }
  for(unsigned int i=0; i<attrVec.size(); i++)
  {
    onAttribute(userData, attrVec[i]);
  }
#endif
  Node* elemNode = _docNode->createElementWithAttributes(const_cast<DOMString *>(nsTriplet.nsUri()),
      const_cast<DOMString *>(nsTriplet.nsPrefix()),
      const_cast<DOMString *>(nsTriplet.localName()),
      attrVec);
}

void DOMParser::onElementEnd(void *userData, NodeNSTriplet nsTriplet)
{
#ifdef _DOM_DBG
  cout << "onElementEnd: element:"
    << nsTriplet.toString()
    << endl;
#endif
  
  _docNode->endElementNS(
        const_cast<DOMString *>(nsTriplet.nsUri()),
        const_cast<DOMString *>(nsTriplet.nsPrefix()),
        const_cast<DOMString *>(nsTriplet.localName()) );
}

void DOMParser::onAttribute(void *userData, AttributeInfo attrInfo)
{
#ifdef _DOM_DBG
  cout << "onAttribute:"
    << " attr: " << attrInfo.toString()
    << endl;
#endif

  AttributeP attrNode = _docNode->createAttributeNS(const_cast<DOMString *>(attrInfo.nsUri()),
      const_cast<DOMString *>(attrInfo.nsPrefix()),
      const_cast<DOMString *>(attrInfo.localName()),
      const_cast<DOMString *>(attrInfo.value()));

  if(!attrNode) {
    ostringstream err;
    err << "failed to create attribute ["  << *attrInfo.localName() << "] ";
    throw DOMException(err.str());
  }
}

void DOMParser::onComment(void *userData, const DOMString* dataPtr)
{
#ifdef _DOM_DBG
  cout << "onComment data:[" << dataPtr->str() << "]"  << endl;
#endif

  Comment* cmt = _docNode->createComment(const_cast<DOMString *>(dataPtr));
  if(!cmt) {
    throw DOMException("failed to create Comment");
  }
}

void DOMParser::onCharacterData(void *userData, 
    const DOMString* charDataPtr)
{
#ifdef _DOM_DBG
  cout << "onCharacterData charBuff:[" << charDataPtr->str() << "]" << endl;
#endif
  if(!charDataPtr) {
    return;
  }

  if(_docNode->stateful()) 
  {
    if(this->isCDATAInProgress()) {
      this->addCDATABuffer(*charDataPtr);
    }
    else
    { // it is a non-CDATA TextNode
      TextNodeP textNode = _docNode->getCurrentElement()->createTextNode(const_cast<DOMString *>(charDataPtr));
      if(!textNode) {
        throw DOMException("failed to create Text");
      }
    }
  }
  else
  {
    TextNodeP textNode = _docNode->createTextNode(const_cast<DOMString *>(charDataPtr));
    if(!textNode) {
      throw DOMException("failed to create Text");
    }
  }
}

void DOMParser::onNamespaceStart(void *userData,
		const DOMString* nsPrefix,
		const DOMString* nsUri)
{
#ifdef _DOM_DBG
    cout << "onNamespaceStart: prefix=" 
      << (nsPrefix ? nsPrefix->str().c_str() : "(null)")
      << " uri=" << (nsUri ? nsUri->str().c_str() : "(null)")
      << endl;
#endif
    _docNode->registerNsPrefixNsUri(nsPrefix, nsUri);
    //delete nsPrefix;
    //delete nsUri;
} 

void DOMParser::onNamespaceEnd(void *userData, 
    const DOMString* nsPrefix) 
{
#ifdef _DOM_DBG
    cout << "onNamespaceEnd: prefix=" 
      << (nsPrefix ? nsPrefix->str().c_str() : "(null)")
      << endl;
#endif
  //delete nsPrefix;
} 


// Here is an example of DocumentType:
//  =========================================
// <!DOCTYPE ex SYSTEM "ex.dtd" [
//  <!ENTITY foo "foo">
//  <!ENTITY bar "bar">
//  <!ENTITY bar "bar2">
//  <!ENTITY % baz "baz">
//  ]>
//  =========================================
//
void DOMParser::onDocTypeStart(void  *userData,
    const DOMString* doctypeNamePtr,
    const DOMString* sysidPtr,
    const DOMString* pubidPtr,
    int   has_internal_subset)
{
  //The has_internal_subset will be non-zero if the DOCTYPE declaration
  //has an internal subset.
#ifdef _DOM_DBG
  cout << "onDocTypeStart: "
    << " doctypeName=" << (doctypeNamePtr ? doctypeNamePtr->str().c_str() : "(null)")
    << " sysid=" << (sysidPtr ? sysidPtr->str().c_str() : "(null)")
    << " pubid=" << (pubidPtr ? pubidPtr->str().c_str() : "(null)")
    << " has_internal_subset=" 
    << ((has_internal_subset != 0) ? true:false)
    << endl;
#endif

  // FIXME:
  // The parse callback currently not implemented for entity/notation objects.
  // For now let's just construct the DocumentType assuming there are no
  // entities/notations inside it. When the parsing info is available for
  // entities/notations, then this creation should be shifted to onNamespaceEnd
  // so that entities/notations can also be used in the constructor.
  DocumentType* docType = _docNode->createDocumentType( doctypeNamePtr, 
                                                        NamedNodeMap(), //FIXME
                                                        NamedNodeMap(), //FIXME
                                                        pubidPtr,
                                                        sysidPtr,
                                                        NULL            // FIXME
                                                      );
}

void DOMParser::onDocTypeEnd(void *userData)
{
#ifdef _DOM_DBG
  cout << "onDocTypeEnd: " << endl;
#endif
}

void DOMParser::onCDATAStart(void *userData)
{
#ifdef _DOM_DBG
  cout << "onCDATAStart: " << endl;
#endif

  this->beginOfCDATASection();
}

void DOMParser::onCDATAEnd(void *userData)
{
#ifdef _DOM_DBG
  cout << "onCDATAEnd: " << endl;
#endif
  
  DOMString text = this->getCDATABuffer();
  DOMStringPtr textPtr = new DOMString(text);
  if(_docNode->stateful() && _docNode->getCurrentElement())
  {
    if(text.length() > 0)
    {
      CDATASection* cdataNode = _docNode->getCurrentElement()->createCDATASection(textPtr);
      //CDATASection* cdataNode = _docNode->createCDATASection(textPtr);
      if(!cdataNode) {
        throw DOMException("failed to create CDATASection");
      }
    }
  }
  else 
  {
    CDATASection* cdataNode = _docNode->createCDATASection(textPtr);
  }

  this->endOfCDATASection();
}

void DOMParser::onPI(void *userData,
    const DOMString* targetPtr,
    const DOMString* dataPtr)
{

#ifdef _DOM_DBG
  cout << "onPI: "
    << " target=" << (targetPtr ? targetPtr->str().c_str() : "(null)")
    << " data=" << (dataPtr ? dataPtr->str().c_str() : "(null)")
    << endl;
#endif
  PI* pi = _docNode->createProcessingInstruction(const_cast<DOMString *>(targetPtr), const_cast<DOMString *>(dataPtr));
  if(!pi) {
    throw DOMException("failed to create PI");
  }
}

#if 0
void DOMParser::createAccumulatedTextNode()
{
  if(_docNode->stateful() && _docNode->getCurrentElement())
  {
    DOMString text = _docNode->getCurrentElement()->getTextBufferOnDocBuild();
    //cout << "onElementStart: text:|" << text << "|" << endl;
    if(text.length() > 0)
    {
      if(_docNode->getCurrentElement()->isTextBufferCDATA())
      {
        DOMStringPtr textPtr = new DOMString(text);
        CDATASection* cdataNode = _docNode->createCDATASection(textPtr);
        _docNode->getCurrentElement()->resetTextBufferOnDocBuild();
        if(!cdataNode) {
          throw DOMException("failed to create CDATASection");
        }
      }
      else // it is a TextNode
      {
        DOMStringPtr textPtr = new DOMString(text);
        TextNode* textNode = _docNode->createTextNode(textPtr);
        _docNode->getCurrentElement()->resetTextBufferOnDocBuild();
        if(!textNode) {
          throw DOMException("failed to create Text");
        }
      }
    }
  }
}
#endif    

//       END :  parser callbacks 



void DOMParser::printTreePreOrder(const Node *node, int depth)
{
  if(!node) {
    return;
  }

#ifdef _DOM_DBG
  string adjust; 
  for(int i=0; i<depth; i++)
    adjust += "  ";

  const NamedNodeMap& atts = node->getAttributes();
  cout << adjust << "nodeName:" <<  node->getNodeName() 
    << " nodeValue=[" << node->getNodeValue() << "]" << endl;
  atts.print();  
  for(unsigned int i=0; i<atts.length(); i++)
  {
    AttributeP att = dynamic_cast<Attribute *>(const_cast<Node *>( atts.item(i)));
    //AttributeP att = dynamic_cast<AttributeP>( atts.item(i));
    if(att)
      cout << adjust << "  attr[" <<  att->getName() << "=" << att->getValue() << "]"  << endl;
  }
#endif

  const NodeList& childNodes = node->getChildNodes();
  for(unsigned int i=0; i<childNodes.getLength(); i++)
  {
    printTreePreOrder(childNodes.item(i), depth+1);
  }
}

void DOMParser::printTree()
{
  cout << "DOM TREE:" << endl;
  printTreePreOrder(_docNode, 0);
}

void DOMParser::parseXmlFileDOM(string filePath)
{
  _docNode = new DOM::Document();
  _docNode->stateful(true);
  int depth = 0;
  this->setUserData(&depth);
  ExpatParser::parseXmlFile(filePath);
}


