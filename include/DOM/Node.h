// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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

#ifndef __DOM_NODE_H__
#define __DOM_NODE_H__

#include <iostream>

#include "DOM/DOMCommonInc.h"
#include "DOM/NamedNodeMap.h"
//#include "DOM/NodeList.h"
#include "XPlus/XPlusObject.h"

/*
   [ courtesy: http://www.w3.org/TR/DOM-Level-2-Core/core.html ]

   Interface                     nodeName                           nodeValue                         attributes
   ============================================================================================================================    
   Attr                       name of attribute               value of attribute                      null
   CDATASection               #cdata-section                  content of the CDATA Section            null
   Comment                   #comment                        content of the comment                  null
   Document                   #document                       null                                    null
   DocumentFragment           #document-fragment              null                                    null
   DocumentType               document type name              null                                    null
   Element                   tag name                        null                                    NamedNodeMap
   Entity                     entity name                     null                                    null
   EntityReference           name of entity referenced       null                                    null
   Notation                   notation name                   null                                    null
   ProcessingInstruction     target                           entire content excluding the target     null
   Text                       #text                           content of the text node                 null


 */
  


namespace DOM
{
 
  static string  sg_nodeTypeString[] =
  {
    "(UNKNOWN_TYPE)"             ,
    "ELEMENT_NODE"               ,
    "ATTRIBUTE_NODE"             ,
    "TEXT_NODE"                  , 
    "CDATA_SECTION_NODE"         ,
    "ENTITY_REFERENCE_NODE"      ,
    "ENTITY_NODE"                ,
    "PROCESSING_INSTRUCTION_NODE",
    "COMMENT_NODE"               ,
    "DOCUMENT_NODE"              ,
    "DOCUMENT_TYPE_NODE"         ,
    "DOCUMENT_FRAGMENT_NODE"     ,
    "NOTATION_NODE"              ,
    "" /* end marker */
  };
  
  class NodeNSTriplet
  {
    private:

      DOMStringPtr _nsUri;
      DOMStringPtr _nsPrefix;
      DOMStringPtr _localName;

    public:

      inline const DOMString* nsUri() const {
        return _nsUri;
      }

      inline const DOMString* nsPrefix() const {
        return _nsPrefix;
      }

      inline const DOMString* localName() const {
        return _localName;
      }

      NodeNSTriplet(
          DOMString* nsUri, 
          DOMString* nsPrefix,
          DOMString* localName 
          ):
        _nsUri(nsUri),
        _nsPrefix(nsPrefix),
        _localName(localName)
      {
      }

      string toString() const 
      {
        ostringstream oss;
        oss << " [ " 
            << ( !nsUri() ? "(NULL)" : nsUri()->str()) << " | "
            << ( !nsPrefix() ? "(NULL)" : nsPrefix()->str())  << " | "
            << ( !localName() ? "(NULL)" : localName()->str() ) 
            << " ] " ;
          return oss.str();
      }

      inline bool operator==(const NodeNSTriplet& nsTriplet) const {

        return ( ( this->nsUri() == nsTriplet.nsUri() ) & 
            ( this->nsPrefix() == nsTriplet.nsPrefix() ) ||
            ( this->localName() == nsTriplet.localName())
            );
      }
  };

  struct AttributeInfo : public NodeNSTriplet
  {

    AttributeInfo(  DOMString* nsUri, 
           DOMString* nsPrefix,
           DOMString* localName,
           DOMString* value ):
      NodeNSTriplet(nsUri, nsPrefix, localName),
      _value(value)
      {
      }
      
      inline const DOMString* value() const {
        return _value;
      }
    
    private:
    DOMStringPtr      _value;
  };


class Node : public virtual XPlus::XPlusObject
{

public:


  typedef enum NodeType
  {
    NODE_TYPE_ALL                  = -1,
    NODE_UNKNOWN                   = 0,

    // from spec:
    ELEMENT_NODE                   = 1,
    ATTRIBUTE_NODE                 = 2,
    TEXT_NODE                      = 3, 
    CDATA_SECTION_NODE             = 4,
    ENTITY_REFERENCE_NODE          = 5,
    ENTITY_NODE                    = 6,
    PROCESSING_INSTRUCTION_NODE    = 7,
    COMMENT_NODE                   = 8,
    DOCUMENT_NODE                  = 9,
    DOCUMENT_TYPE_NODE             = 10,
    DOCUMENT_FRAGMENT_NODE         = 11,
    NOTATION_NODE                  = 12,
    NAMESPACE_NODE                 = 50 /* TODO: verify enum from specs */  
  } NodeType;


protected:

  DOMStringPtr              _nodeName;
  DOMStringPtr              _nodeValue;
  NodeType                  _nodeType;

  Node*                   _parentNode;
  NodeList                _childNodes;
  //NodePtr                   _firstChild;
  //NodePtr                   _lastChild;
  Node*                   _previousSibling;
  Node*                   _nextSibling;
  NamedNodeMap              _attributes;

  // Modified in DOM Level 2:
  Document*               _ownerDocument;

  // Introduced in DOM Level 2:
  DOMStringPtr              _nsUri;
  DOMStringPtr              _nsPrefix;
  DOMStringPtr              _localName;

  //impl needs
  int                       _depth;
  bool                      _removedFromParentList;
  
public:

  Node(
      DOMString* nodeName,
      NodeType nodeType,
      DOMString* nsURI,
      DOMString* nsPrefix,
      Document* ownerDocument=NULL, 
      DOMString* nodeValue=NULL,
      Node* parentNode=NULL,
      Node* prevSibling=NULL,
      Node* nextSibling=NULL
  );

  Node() {cout << "DOM::Node::Node()\n";};

  virtual ~Node();

  virtual inline const DOMString* getNodeName() const {
    return _nodeName;
  }
  virtual inline  DOMString* getNodeName()  {
    return _nodeName;
  }
  virtual inline const DOMString* getNodeValue() const {
    return _nodeValue;
  }
  virtual inline void setNodeValue(DOMString* nodeValue) {
    _nodeValue = nodeValue;
  }

  virtual inline NodeType getNodeType() const {
    return _nodeType;
  }
  virtual inline void setNodeType(NodeType nodeType) {
    _nodeType = nodeType;
  }

  virtual inline Node* getParentNode() const {
    return _parentNode;
  }

  virtual void setParentNode(Node* parentNode);

  virtual inline const NodeList& getChildNodes() const {
    return _childNodes;
  }
  
  virtual inline NodeList& getChildNodes() {
    return _childNodes;
  }

  virtual  Node* getFirstChild() const ;

  virtual  Node* getLastChild() const;

  virtual inline Node* getPreviousSibling() const {
    return _previousSibling;
  }

  virtual inline void setPreviousSibling(Node* prevSibl) {
    _previousSibling = prevSibl;
  }

  virtual inline Node* getNextSibling() const {
    return _nextSibling;
  }

  virtual inline void setNextSibling(Node* nextSibl) {
    _nextSibling = nextSibl;
  }

  virtual inline const NamedNodeMap& getAttributes() const {
    return _attributes;
  }

  virtual Document* getOwnerDocument();
  virtual const Document* getOwnerDocument() const ;

  virtual inline DOMString* getNamespaceURI() {
    return _nsUri;
  }
  virtual inline const DOMString* getNamespaceURI() const {
    return _nsUri;
  }
  virtual inline void setNamespaceURI(DOMString* nsUri) {
    _nsUri = nsUri;
    this->registerNsPrefixNsUri();
  }

  virtual inline DOMString* getNamespacePrefix() {
    return _nsPrefix;
  }
  virtual inline const DOMString* getNamespacePrefix() const {
    return _nsPrefix;
  }
  virtual inline void setNamespacePrefix(DOMString* nsPrefix) {
    _nsPrefix = nsPrefix;
    this->registerNsPrefixNsUri();
  }
  

  virtual inline const DOMString* getLocalName() const {
    return _localName;
  }

  virtual Node* insertAt(Node* newChild, unsigned int pos);
  virtual Node* insertFront(Node* newChild);
  virtual Node* insertBack(Node* newChild); 
  virtual Node* insertAfter(Node* newChild, Node* refChild);//not in DOM spec
  virtual Node* insertBefore(Node* newChild, Node* refChild);
  virtual Node* insertBetween(Node* newChild, Node *prevChild, Node *nextChild);
  virtual Node* replaceChild(Node* newChild, Node* oldChild);
  virtual void removeChild(Node* oldChild);
  // FIXME duplicate of insertBack
  virtual Node* appendChild(Node* newChild);
  unsigned int countPreviousSiblingsOfType(Node::NodeType nodeType) const;
  unsigned int countChildrenOfType(Node::NodeType nodeType) const;
  void removeChildrenOfType(Node::NodeType nodeType);

  virtual bool hasChildNodes() const;

  virtual Node* cloneNode(bool deep) const;

  // Modified in DOM Level 2:
  virtual void normalize();

  // Introduced in DOM Level 2:
  virtual bool isSupported(DOMString* feature, DOMString* version) const;

  virtual inline bool hasAttributes() const {
    return (_attributes.length() > 0);
  }

  //impl apis
  void spitToOutputStream(ostream &os);
  static string enumToString(NodeType nodeType);
  static NodeType stringToEnum(string nodeTypeStr);

  virtual TextNode* createTextNode(DOMString *value);
  TextNode* createChildTextNodeAt(DOMString *value, unsigned int pos);
  virtual TextNode* createChildTextNode(DOMString* value);
  virtual TextNode* createChildTextNodeAfterNode(DOMString *value, Node *prevNode);
  
  virtual CDATASection* createCDATASection(DOMString* data);
  CDATASection* createChildCDATASection(DOMString* data);
  
  bool prettyPrint() const ;

  inline int getDepth() const{
    return _depth;
  }
  inline void setDepth(int depth) {
    _depth = depth;
  }
  inline void removedFromParentList(bool b) {
    _removedFromParentList = b;
  }

  void registerNsPrefixNsUri();

  bool isDocumentElement() const;

};

}
#endif
