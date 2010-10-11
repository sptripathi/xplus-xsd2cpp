// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Free Software Foundation, Inc.
// Author: Satya Prakash Tripathi
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
  _docXmlDecl.version = version;
  _docXmlDecl.encoding = encoding;
  _docXmlDecl.standalone = (standalone==1);

  //FIXME : here may not be the right place
  _docNode->setXmlDecl(_docXmlDecl);
}

void DOMParser::onElementStart(void *userData, NodeNSTriplet nsTriplet)
{
#ifdef _DOM_DBG
  cout << "onElementStart: element:"
    << nsTriplet.toString()
    << endl;
#endif

  _elemTextBuffer = "";

  Node* elemNode = _docNode->createElementNS(
      const_cast<DOMString *>(nsTriplet.nsUri()),
      const_cast<DOMString *>(nsTriplet.nsPrefix()),
      const_cast<DOMString *>(nsTriplet.localName()) );

  if(!elemNode) {
    ostringstream err;
    err << "failed to create element ["  << *nsTriplet.localName() << "] ";
    throw DOMException(err.str());
  }
}

void DOMParser::onElementEnd(void *userData, NodeNSTriplet nsTriplet)
{
#ifdef _DOM_DBG
  cout << "onElementEnd: element:"
    << nsTriplet.toString()
    << endl;
#endif
  
  if(_elemTextBuffer.length() > 0 ) 
  {
    //TODO: make sure this new doesnt leak
    TextNodeP textNode = _docNode->createTextNode(new DOMString(_elemTextBuffer));
    if(!textNode) {
      throw DOMException("failed to create Text");
    }
  }
  _elemTextBuffer = "";

  _docNode->endElementNS(
        const_cast<DOMString *>(nsTriplet.nsUri()),
        const_cast<DOMString *>(nsTriplet.nsPrefix()),
        const_cast<DOMString *>(nsTriplet.localName()) );

}

void DOMParser::onAttribute(void *userData, NodeNSTriplet nsTriplet,
    const DOMString* value)
{
#ifdef _DOM_DBG
  cout << "onAttribute:"
    << " attr: " << nsTriplet.toString()
    << endl;
#endif

  AttributeP attrNode = _docNode->createAttributeNS(const_cast<DOMString *>(nsTriplet.nsUri()),
      const_cast<DOMString *>(nsTriplet.nsPrefix()),
      const_cast<DOMString *>(nsTriplet.localName()),
      const_cast<DOMString *>(value));

  if(!attrNode) {
    ostringstream err;
    err << "failed to create attribute ["  << *nsTriplet.localName() << "] ";
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
  
  if( charDataPtr) {
    _elemTextBuffer += *charDataPtr;
  }

  /*
  TextNodeP textNode = _docNode->createTextNode(const_cast<DOMString *>(charDataPtr));
  if(!textNode) {
    throw DOMException("failed to create Text");
  }
  */
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
    delete nsPrefix;
    delete nsUri;
    //_docNode->createNamespace(nsUri);
} 

void DOMParser::onNamespaceEnd(void *userData, 
    const DOMString* nsPrefix) 
{
#ifdef _DOM_DBG
    cout << "onNamespaceEnd: prefix=" 
      << (nsPrefix ? nsPrefix->str().c_str() : "(null)")
      << endl;
#endif
  delete nsPrefix;
} 

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
}

void DOMParser::onCDATAEnd(void *userData)
{
#ifdef _DOM_DBG
  cout << "onCDATAEnd: " << endl;
#endif
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
  PI* pi = _docNode->createProcessingInstruction(
      const_cast<DOMString *>(targetPtr), 
      const_cast<DOMString *>(dataPtr));
  if(!pi) {
    throw DOMException("failed to create PI");
  }
}
    
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
