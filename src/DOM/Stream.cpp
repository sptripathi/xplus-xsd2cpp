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

#include "DOM/Stream.h"
#include "DOM/DOMParser.h"
#include "DOM/DOMException.h"

using namespace DOM;

namespace DOM {

DOMString prettyPrintPadding(int depth)
{
  ostringstream padding;
  for(int i=0; i<depth-1; i++) {
    padding << "  ";
  }
  return DOMString(padding.str());
}

bool matchNamespace(const DOMString* nsUri1, const  DOMString* nsUri2)
{
  if( 
      (!nsUri1 && !nsUri2)  ||
      (nsUri1 && nsUri2 && (*nsUri1 == *nsUri2))
    )
  {
    return true;
  }
  
  return false;
}

XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const Node& node)
{
  switch(node.getNodeType())
  {
    case Node::ELEMENT_NODE:
      {
        const Element& element = dynamic_cast<const Element &>(node);
        outputElement(s, element);
      }
      break;
    case Node::ATTRIBUTE_NODE:
      {
        const Attribute& attr = dynamic_cast<const Attribute &>(node);
        outputAttribute(s, attr);
      }
      break;
    case Node::TEXT_NODE:
      {
        const TextNode& tn = dynamic_cast<const TextNode &>(node);
        outputTextNode(s, tn);
      }
      break;
    case Node::CDATA_SECTION_NODE:
      {
        const CDATASection& cdataNode = dynamic_cast<const CDATASection &>(node);
        outputCDATASection(s, cdataNode);
      }
      break;
    case Node::ENTITY_REFERENCE_NODE:
      break;
    case Node::ENTITY_NODE:
      break;
    case Node::PROCESSING_INSTRUCTION_NODE:
      {
        const PI& pi = dynamic_cast<const PI &>(node);
        outputPI(s, pi);
      }
      break;
    case Node::COMMENT_NODE:
      {
        const Comment& cmt = dynamic_cast<const Comment &>(node);
        outputComment(s, cmt);
      }
      break;
    case Node::DOCUMENT_NODE:
      {
        const Document& doc = dynamic_cast<const Document &>(node);
        outputDocument(s, doc);
      }
      break;
    case Node::DOCUMENT_TYPE_NODE:
      {
        const DocumentType& docType = dynamic_cast<const DocumentType &>(node);
        outputDocumentType(s, docType);
      }
      break;
    case Node::DOCUMENT_FRAGMENT_NODE:
      break;
    case Node::NOTATION_NODE:
      break;

    default:
      break;
  }

  return s;
}

void outputXmlDecl(XPlusCharOutputStream& s, const Document& doc)
{
  // template:
  //"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"
  s << "<?xml";
  
  if(doc.version() != XML_VERSION_UNSPECIFIED) {
    s << " version=\"" << doc.versionString() << "\"";
  }
  else {
    s << " version=\"1.0\"";
  }

  if(doc.encoding() != TextEncoding::UNSPECIFIED) {
    s << " encoding=\"" << doc.encodingString() << "\"";
  }
  
  if(doc.standalone() != STANDALONE_UNSPECIFIED) {
    s << " standalone=\"" << doc.standaloneString() << "\"";
  }

  s << "?>";
  s << endl;
}


void outputDocument(XPlusCharOutputStream& s, const Document& doc)
{
#ifdef XPLUS_UNICODE_WCHAR_T
  short BOM_UTF16 =  0xFEFF ;
  //FIXME: system call, replace with C/C++ call
  s.write( (const char*)&BOM_UTF16, sizeof(short));
#endif
  outputXmlDecl(s,doc);
  
  const NodeList& childNodes = doc.getChildNodes();
  for(unsigned int i=0; i<childNodes.getLength(); i++)
  {
    const Node* childNode = childNodes.item(i);
    s << *childNode;
  }
}


void outputDocElementNamespaces(XPlusCharOutputStream& s, const Element& e)
{
  if(!e.getOwnerDocument()){
    return;
  }
  
  //output prefixedNamespaces
  const map<DOMString, DOMString>& prefixedNamespaces = e.getOwnerDocument()->getPrefixedNamespaces();
  map<DOMString, DOMString>::const_iterator it2 = prefixedNamespaces.begin();
  for( ; it2 != prefixedNamespaces.end(); it2++)
  {
    s << " xmlns:" << it2->first << "=\"" << it2->second << "\"";
  }

  //output unprefixedNamespaces
  const list<DOMString>& unprefixedNamespaces = e.getOwnerDocument()->getUnprefixedNamespaces();
  list<DOMString>::const_iterator it = unprefixedNamespaces.begin();
  for( ; it != unprefixedNamespaces.end(); it++)
  {
    s << " xmlns:" << e.getOwnerDocument()->getNsPrefixForNsUriImplicit(*it)
      << "=\"" << *it << "\"";
  }
}

void outputNsPrefix(XPlusCharOutputStream& s, const Node& node)
{
  // if the element/attribute has nsPrefix, it has to have nsUri
  if(!node.getNamespaceURI()) {
    return;
  }
  switch(node.getNodeType()) {
    case Node::ELEMENT_NODE:
    case Node::ATTRIBUTE_NODE:
      break;

    default:
      return;
  }
  // output nsPrefix if available else output implicit nsPrefix
  if( (node.getNamespacePrefix() != (DOMStringP)NULL) && (node.getNamespacePrefix()->length() > 0) ) {
    s << *node.getNamespacePrefix() << DOMString(":");
  }
  else 
  {
    if( node.getOwnerDocument() )
    {
      DOMString nsPrefix = node.getOwnerDocument()->getNsPrefixForNsUriImplicit(*node.getNamespaceURI());
      if(nsPrefix.length() > 0) {
        s << nsPrefix << DOMString(":");
      }
    }
    else {
      //TODO: throw exception
    }
  }
}

void outputElement(XPlusCharOutputStream& s, const Element& e)
{
  if(e.isDocumentElement() && e.getPreviousSibling()) {
    s << endl;
  }
  else if(!e.isDocumentElement()) {
    s << endl; 
  }

  DOMString padding;
  if(e.prettyPrint()) {
    padding = prettyPrintPadding(e.getDepth());
    s << padding;
  }

  // element begin
  s << DOMString("<");

  // nsPrefix
  outputNsPrefix(s, e);

  // element name
  s << *e.getNodeName();
  
  //s << " depth=\"" << e.getDepth() << "\"" ;

  //streamOutAttribute
  const NamedNodeMap& atts = e.getAttributes();
  for(unsigned int i=0; i < atts.length(); i++)
  {
    const Node* att = atts.item(i);
    if(att) {
      s << *att;
    }
  }  
  
  // namespaces: 
  // Strategy1 :
  //   - spit namespaces in documentRoot element
  //   - provide for nsPrefix for those which are not
  //     in the namespace of the documentRoot  
  // TODO: support other strategies too
  if(e.isDocumentElement()) {
    outputDocElementNamespaces(s, e);
  }
  
  int cntChildren = e.getChildNodes().getLength();
  int cntChildElements = 0;
  if(cntChildren > 0)
  {
    // end of elem begin
    s << DOMString(">"); 

    //streamout all child nodes
    const Node *node = e.getFirstChild();
    while(node)
    {
      if(node->getNodeType() == Node::TEXT_NODE)
      {
        ostringstream streamText;
        bool prevSiblPresent = (node->getPreviousSibling() ? true: false);
        int textDepth = node->getDepth();
        while(node && 
              ((node->getNodeType() ==  Node::TEXT_NODE) || (node->getNodeType() ==  Node::CDATA_SECTION_NODE) ) 
             )
        {
          streamText << *node;
          node = node->getNextSibling();
        }
        DOMString strText = streamText.str();
        if( e.prettyPrint() ) 
        {
          strText.trim(UTF8FNS::isSpaceChar);  
          if(strText.length()>0)
          {
            if(prevSiblPresent) {
              DOMString padding = prettyPrintPadding(textDepth);
              s << endl;
              s << padding;
            }
            s << strText;
          }
        }
        else {
          s << strText;
        }
      }
      else
      {
        if(node->getNodeType() ==  Node::ELEMENT_NODE) {
          cntChildElements++;
        }
        s << *node;
        node = node->getNextSibling();
      }
    }
    //element end
    if( e.prettyPrint() && (cntChildElements > 0) )
    {
      s << endl;
      s << padding;
    }
    s << DOMString("</") ;
    outputNsPrefix(s, e);
    s << *e.getNodeName() << DOMString(">");
  }
  else
  {
    // end of elem begin
    s << DOMString("/>"); 
  }
}

void outputAttribute(XPlusCharOutputStream& s, const Attribute& attr)
{
  s << DOMString(" ");

  // nsPrefix
  outputNsPrefix(s, attr);

  s << *attr.getNodeName() << DOMString("=\"");
  const NodeList& childNodes = attr.getChildNodes();
  for(unsigned int i=0; i<childNodes.getLength(); i++)
  {
    const Node* childNode = childNodes.item(i);
    if(childNode->getNodeType() == Node::TEXT_NODE) {
      s << *childNode;
    }
  }
  s << DOMString("\"");
}
        
void outputCDATASection(XPlusCharOutputStream& s, const CDATASection& cdataNode)
{
  if( !cdataNode.getData() || (cdataNode.getData()->length() == 0) ) {
    return;
  }

  DOMString dataStr = *cdataNode.getData();
  // stream-out the text data
  s << "<![CDATA[" << dataStr << "]]>";
}

void outputTextNode(XPlusCharOutputStream& s, const TextNode& tn)
{
  if( !tn.getData() || (tn.getData()->length() == 0) ) {
    return;
  }
  
  // stream-out the text data
  DOMString dataStr = *tn.getData();
  DOMString::const_iterator cit = dataStr.begin();
  // TBD: it seems the text data should have its characters replaced with
  // their respective character-entities symbols. Starting with [><] set 
  // for now
  for( ; cit != dataStr.end(); ++cit)
  {
    if(*cit == '<') {
      s << "&lt;";
    }
    else if(*cit == '>') {
      s << "&gt;";
    }
    else {
      s << *cit ;
    }
  }
}

/*
<!DOCTYPE chapter SYSTEM "../dtds/chapter.dtd">
<!DOCTYPE chapter PUBLIC "-//OASIS//DTD DocBook XML//EN" "../dtds/chapter.dtd">
*/
void outputDocumentType(XPlusCharOutputStream& s, const DocumentType& docType)
{
  if( docType.getPreviousSibling() ) {
    s << endl;
  }

  s << "<!DOCTYPE";
  if(docType.getName()) {
    s << " " << *docType.getName();
  }

  if(docType.getPublicId()) {
    s << " PUBLIC \"" << *docType.getPublicId() << "\"";
  }
  
  if(docType.getSystemId()) {
    s << " SYSTEM \"" << *docType.getSystemId() << "\"";
  }

  s << ">";
}

void outputPI(XPlusCharOutputStream& s, const PI& pi)
{
  if(pi.getPreviousSibling() ) {
    s << endl;
  }

  if(pi.getTarget()) 
  {
    s << "<?";
    s << *pi.getTarget() << " ";
    if(pi.getData()) {
      s << *pi.getData();
    }
    s << "?>";
  }
}

void outputComment(XPlusCharOutputStream& s, const Comment& cmt)
{
  // The strategy is to output all top-level comments newline separated, 
  // regardless of whether prettyPrint is on or not.
  // expat doesnt report TextNodes as a child of Document, it only does so
  // as a child of element/attribute.
  // So we can safely follow this trick: 
  if( (cmt.getParentNode() == cmt.getOwnerDocument()) && cmt.getPreviousSibling() ) 
  {
    s << endl;
    DOMString padding = prettyPrintPadding(cmt.getDepth());
    s << padding;
  }
  if( cmt.prettyPrint() )
  {
  }
  
  s << DOMString("<!--") << *cmt.getData() << DOMString("-->");
    
  // only top level comments need to be follwed by a newline because
  // all non-top level nodes like element/Text output newline before themselves
  //if( cmt.prettyPrint() && (cmt.getParentNode() == cmt.getOwnerDocument()) ) 
  //if( cmt.prettyPrint() && (cmt.getPreviousSibling() || cmt.getNextSibling() ))
  /*
  if( cmt.getParentNode() == cmt.getOwnerDocument() ) 
  {
    s << "\n";
  }
  */
}

XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const DOMString& domStr)
{
  for(unsigned int i=0; i<domStr.length(); i++)  {
    //s << domStr.at(i);
    XML_Char xchar = domStr.at(i);
    s.write((const char*)&xchar, sizeof(xchar));
  }
  return s;
}

XPlusCharInputStream& operator>>(XPlusCharInputStream& s, Document& docNode)
{
  AutoPtr<DOMParser> parser = new DOMParser(&docNode);
  int depth = 0;
  parser->setUserData(&depth);

  //parser->parseInputStream(s);
  //TODO: set fail bit on XPlusCharInputStream on parse failure 
  try {
    parser->parseInputStream(s);
  }
  catch(XPlus::Exception& ex) {
    //TODO: dump line,col only when reading file
    ostringstream oss;
    oss << parser->getCurentLineNum() << ", " << parser->getCurentColumnNum();
    ex.setContext("line,column", oss.str());  
    throw;
  }
  catch(...) {
    cerr << "\n\nCaught Unknown Exception \n\n" << endl;
  }
  return s;
}


}
