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

#ifndef __DOM_STREAM_H__
#define __DOM_STREAM_H__

#include <istream>
#include <ostream>
#include <fstream>

#include "DOM/DOMAllInc.h"
#include "DOM/Node.h"
#include "DOM/Document.h"

using namespace std;

namespace  DOM {


// The byte input stream is always a narrow stream.
typedef std::istream XPlusByteInputStream;
typedef std::ostream XPlusByteOutputStream;

#if defined(XPLUS_UNICODE_WCHAR_T)
// Unicode - use wide streams
typedef std::wistream XPlusCharInputStream;
typedef std::wostream XPlusCharOutputStream;
typedef std::wifstream XPlusFileInputStream;
typedef std::wofstream XPlusFileOutputStream;

#else
// Characters are UTF-8 encoded
typedef std::istream XPlusCharInputStream;
typedef std::ostream XPlusCharOutputStream;
typedef std::ifstream XPlusFileInputStream;
typedef std::ofstream XPlusFileOutputStream;
#endif


void outputXmlDecl(XPlusCharOutputStream& s, const Document& doc);
void outputDocumentType(XPlusCharOutputStream& s, const DocumentType& docType);
XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const DOM::Node& node);
void outputDocument(XPlusCharOutputStream& s, const DOM::Document& doc);
void outputPI(XPlusCharOutputStream& s, const PI& pi);
void outputElement(XPlusCharOutputStream& s, const DOM::Element& e);
void outputAttribute(XPlusCharOutputStream& s, const DOM::Attribute& attr);
void outputTextNode(XPlusCharOutputStream& s, const DOM::TextNode& tn);
void outputCDATASection(XPlusCharOutputStream& s, const CDATASection& cdataNode);
void outputComment(XPlusCharOutputStream& s, const DOM::Comment& cmt);
void outputDocElementNamespaces(XPlusCharOutputStream& s, const Element& e);
XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const DOM::DOMString& domStr);
XPlusCharInputStream& operator>>(XPlusCharInputStream& s, DOM::Document& docNode);
}



#endif
