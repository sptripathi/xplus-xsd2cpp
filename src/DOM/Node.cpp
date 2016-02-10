// This file is part of XmlPlus package
// 
// Copyright (C)-2011   2010-2013 Satya Prakash Tripathi
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

#include "DOM/Node.h"
#include "DOM/TextNode.h"
#include "DOM/Element.h"
#include "DOM/DOMException.h"
#include "DOM/Document.h"

using namespace std;

namespace DOM
{

  Node::Node(
      DOMString* nodeName,
      NodeType nodeType, 
      DOMString* nsURI,
      DOMString* nsPrefix,
      Document* ownerDocument,
      DOMString* nodeValue,
      Node* parentNode,
      Node* prevSibling,
      Node* nextSibling
      ):
    XPlusObject("Node"),  
    _nodeName(nodeName),
    _nodeValue(nodeValue),
    _nodeType(nodeType),
    _parentNode(parentNode),
    _previousSibling(prevSibling),
    _nextSibling(nextSibling),
    _ownerDocument(ownerDocument),
    _nsUri(nsURI),
    _nsPrefix(nsPrefix),
    _depth(0),
    _removedFromParentList(false)
  { 
    //cout << "constructing Node: nodeName:" << *_nodeName << " ptr=" << this << endl;
    if( 
        (_nodeType == ELEMENT_NODE) ||
        (_nodeType == ATTRIBUTE_NODE)
      )
    {
      _localName = _nodeName;
    }

    this->registerNsPrefixNsUri();

    switch(_nodeType)
    {
      case ELEMENT_NODE:
      case TEXT_NODE:
      case COMMENT_NODE:
      case CDATA_SECTION_NODE:
      case DOCUMENT_TYPE_NODE:
      case PROCESSING_INSTRUCTION_NODE:
        if(_parentNode) 
        {
          if(_previousSibling && !_nextSibling) {
            _parentNode->insertAfter(this, _previousSibling);
          }
          else if(_nextSibling && !_previousSibling) {
            _parentNode->insertBefore(this, _nextSibling);
          }
          else if(_nextSibling && _previousSibling) {
            _parentNode->insertBetween(this, _previousSibling, _nextSibling);
          }
          else {
            _parentNode->appendChild(this);
          }
        }
        break;
      
      default:
        break;
    }

    if(_parentNode && (_nodeType != ATTRIBUTE_NODE)) 
    {
      // set depth
      ElementP parentElem = dynamic_cast<ElementP>(_parentNode);
      if(parentElem) {
        this->setDepth(parentElem->getDepth()+1);
      }
      else {
        this->setDepth(1);
      }
    }
  }

/*
  
    //debug:
  void Node::print()
  {
    cout << " nodeName:" << _nodeName
        << " nodeValue:" << _nodeValue
        << " parentNode: " << _parentNode
        << " nsUri:" << _nsUri
        << " nsPrefix:" << _nsPrefix
        << " localName:" << _localName
        << endl;
    cout << "children:" << endl;
      _childNodes.print();
  }
  */

  void Node::setParentNode(Node* parentNode)
  {
    _parentNode = parentNode;

    if(_parentNode && (_nodeType!=ATTRIBUTE_NODE)) 
    {
      // set depth
      ElementP parentElem = dynamic_cast<ElementP>(_parentNode);
      if(parentElem) {
        this->setDepth(parentElem->getDepth()+1);
      }
      //meaning Document is parent
      else {
        this->setDepth(1);
      }
    }
  }

  Node::~Node()
  {
    //cout << "destructing Node: nodeName:" << *_nodeName << " ptr=" << this << endl;
    //cout << "    ";  this->printRefCnt();
    if(this->getParentNode() && !_removedFromParentList) {
      //this->dontFree(true);
      this->getParentNode()->removeChild(this);  
    }
  }

  Document* Node::getOwnerDocument() {
    return _ownerDocument;
  }

  const Document* Node::getOwnerDocument() const {
    return _ownerDocument;
  }
  
  Node* Node::insertAt(Node* newChild, unsigned int pos) {
    newChild->setParentNode(this);
    return _childNodes.insertAt(newChild, pos);
  }
  
  Node* Node::insertFront(Node* newChild) {
    newChild->setParentNode(this);
    return _childNodes.insertFront(newChild);
  }
  
  Node* Node::insertBack(Node* newChild) {
    newChild->setParentNode(this);
    return _childNodes.insertBack(newChild);
  }

  Node* Node::insertAfter(Node* newChild, Node* refChild) {
    newChild->setParentNode(this);
    return _childNodes.insertAfter(newChild, refChild);
  }

  Node* Node::insertBefore(Node* newChild, Node* refChild) {
    newChild->setParentNode(this);
    return _childNodes.insertBefore(newChild, refChild);
  }
  
  Node* Node::insertBetween(Node* newChild, Node *prevChild, Node *nextChild) {
    newChild->setParentNode(this);
    return _childNodes.insertBetween(newChild, prevChild, nextChild);
  }

  Node* Node::replaceChild(Node* newChild, Node* oldChild) {
    newChild->setParentNode(this);
    return _childNodes.replaceNode(newChild, oldChild);
  }

  void Node::removeChild(Node* oldChild) {
    _childNodes.removeNode(oldChild);
  }

  Node* Node::appendChild(Node* newChild) {
    newChild->setParentNode(this);
    return _childNodes.insertBack(newChild);
  }    

  bool Node::hasChildNodes() const {
    return (_childNodes.getLength() > 0) ;
  }

  Node* Node::cloneNode(bool deep) const
  {
    return NULL; //TODO
  }

  Node* Node::getFirstChild() const 
  {
    if(_childNodes.getLength() > 0) {
      //return _childNodes.item(0);
      return _childNodes.front();
    }
    return NULL;
  }

  Node* Node::getLastChild() const 
  {
    unsigned long len = _childNodes.getLength();
    if(len > 0) {
      //return _childNodes.item(len-1);
      return _childNodes.back();
    }
    return NULL;
  }


  // Modified in DOM Level 2:
  void Node::normalize()
  {
    return; //TODO
  }

  // Introduced in DOM Level 2:
  bool Node::isSupported(DOMString* feature, DOMString* version) const
  {
    return false; //TODO
  }

  void Node::spitToOutputStream(ostream& os)
  {
    //TODO: use expanded/compressed(tree) as options
    if(1)
    {
      os << "Node + "
        << enumToString(getNodeType()) << " | "
        << ( !getNamespaceURI() ? "(NULL)" : getNamespaceURI()->str()) << " | "
        << ( !getNamespacePrefix() ? "(NULL)" : getNamespacePrefix()->str())  << " | "
        << ( !getNodeName() ? "(NULL)" : getNodeName()->str() ) << " | "
        //<< ( !getNodeValue() ? "(NULL)" : getNodeValue()->str() ) << " | "
        << endl;
      os << " childNodes: {";
      _childNodes.print();
      os << "  }"<< endl;
      
      os << " attributes: {";
      _attributes.print();
      os << "  }"<< endl;
      
    }
    if(0)
    {
      os << "Node +\n";
      os << "     |\n";
      os << "     *--- localName: [" << getNodeName()->str() << "]\n";
      os << "     |\n";
      os << "     *--- type: [" << getNodeType() << "]\n";
      if(getNamespaceURI()) {
        os << "     |\n";
        os << "     *--- nsUri: [" << getNamespaceURI()->str() << "]\n";
      }
      else {
        os << "     |\n";
        os << "     *--- nsUri: [ (NULL) ]\n";
      }
      if(getNamespacePrefix()) {
        os << "     |\n";
        os << "     *--- nsPrefix: [" << getNamespacePrefix()->str() << "]\n";
      }
      else {
        os << "     |\n";
        os << "     *--- nsPrefix: [ (NULL) ] \n" ;
      }
    }
  }

  string Node::enumToString(Node::NodeType nodeType)
  {
    if(nodeType >=0) {
      return sg_nodeTypeString[nodeType];
    }
    return "(ERROR)";
  }

  Node::NodeType Node::stringToEnum(string nodeTypeStr)
  {
    for(unsigned int i=1; sg_nodeTypeString[i] != ""; i++)
    {
      if(nodeTypeStr == sg_nodeTypeString[i]) {
        Node::NodeType type = static_cast<Node::NodeType>(i);
        return type;
      }
    }
    return Node::NODE_UNKNOWN;
  }
  
  TextNode* Node::createChildTextNodeAt(DOMString *value, unsigned int pos)
  {
    if( 
        (_nodeType == ELEMENT_NODE) ||
        (_nodeType == ATTRIBUTE_NODE)
      )
    {
      if(!value) {
        return NULL;
      }
      TextNode *txtNode = new TextNode(value, this->getOwnerDocument());
      this->insertAt(txtNode, pos);
      txtNode->setParentNode(this);
      return txtNode; 
    }
    else {
      throw DOMException("TextNode is allowed only inside ATTRIBUTE_NODE or ELEMENT_NODE");
    }
  }
  
  TextNode* Node::createChildTextNodeAfterNode(DOMString *value, Node *prevNode) 
  {
    if( 
        (_nodeType == ELEMENT_NODE) ||
        (_nodeType == ATTRIBUTE_NODE)
      )
    {
      if(!value) {
        return NULL;
      }
      return new TextNode(value, this->getOwnerDocument(), this, prevNode);
    }
    else {
      throw DOMException("TextNode is allowed only inside ATTRIBUTE_NODE or ELEMENT_NODE");
    }
  }


  TextNode* Node::createTextNode(DOMString* value) 
  {
    return createChildTextNode(value);
  }

  CDATASection* Node::createChildCDATASection(DOMString* data)
  {
    if( 
        (_nodeType == ELEMENT_NODE) ||
        (_nodeType == ATTRIBUTE_NODE)
      )
    {
      CDATASection* pCDATA = NULL;
      if(data) {
        pCDATA = new CDATASection(data, this->getOwnerDocument(), this);
      }
      if(_nodeType == ATTRIBUTE_NODE) {
        setNodeValue(data); //attribute with CDATA:FIXME ????
      }
      return pCDATA;
    }
    else {
      throw DOMException("CDATASection is allowed only inside ATTRIBUTE_NODE or ELEMENT_NODE");
    }
  }

  CDATASection* Node::createCDATASection(DOMString* data)
  {
    return createChildCDATASection(data);
  }

  TextNode* Node::createChildTextNode(DOMString* value) 
  {
    if( 
        (_nodeType == ELEMENT_NODE) ||
        (_nodeType == ATTRIBUTE_NODE)
      )
    {
      TextNode *pText = NULL;
      if(value) {
        pText = new TextNode(value, this->getOwnerDocument(), this);
      }
      if(_nodeType == ATTRIBUTE_NODE) {
        setNodeValue(value);
      }
      return pText;
    }
    else {
      throw DOMException("TextNode is allowed only inside ATTRIBUTE_NODE or ELEMENT_NODE");
    }
  }


  bool Node::prettyPrint() const {
     return (getOwnerDocument() ? getOwnerDocument()->prettyPrint() : false);
  }

  bool Node::isDocumentElement() const {
    return ((_nodeType == ELEMENT_NODE) && (getDepth()==1));
  }

  void Node::registerNsPrefixNsUri()
  {
    if(_ownerDocument) {
      // element's nsPrefix, nsURI is stored with Document so that
      // DOM operations at Document level(eg. writing-xml) could use
      // namespaces at documentElement's level.
      _ownerDocument->registerNsPrefixNsUri(_nsPrefix, _nsUri);
    }
  }

  unsigned int Node::countPreviousSiblingsOfType(Node::NodeType nodeType) const
  {
    Node *node = this->getPreviousSibling();
    unsigned int cnt=0;
    while(node!= NULL) 
    {
      if(node->getNodeType() == nodeType) {
        ++cnt;
      }
      node = node->getPreviousSibling();
    }
    return cnt;
  }

  unsigned int Node::countChildrenOfType(Node::NodeType nodeType) const
  {
    unsigned int cnt=0;
    for(unsigned int i=0; i<_childNodes.getLength(); i++)
    {
      Node* node = _childNodes.item(i);
      if(node->getNodeType() == nodeType) {
        ++cnt;
      }
    }
    return cnt;
  }

  void Node::removeChildrenOfType(Node::NodeType nodeType)
  {
    for(int i=0; i<(int)_childNodes.getLength(); i++)
    {
      Node* node = _childNodes.item(i);
      if(node->getNodeType() == nodeType) 
      {
        _childNodes.removeNode(node);
        i--;
      }
    }
  }




}
