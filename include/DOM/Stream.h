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
XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const DOM::Node& node);
void outputDocument(XPlusCharOutputStream& s, const DOM::Document& doc);
void outputElement(XPlusCharOutputStream& s, const DOM::Element& e);
void outputAttribute(XPlusCharOutputStream& s, const DOM::Attribute& attr);
void outputTextNode(XPlusCharOutputStream& s, const DOM::TextNode& tn);
void outputComment(XPlusCharOutputStream& s, const DOM::Comment& cmt);
void outputDocElementNamespaces(XPlusCharOutputStream& s, const Element& e);
XPlusCharOutputStream& operator<<(XPlusCharOutputStream& s, const DOM::DOMString& domStr);
XPlusCharInputStream& operator>>(XPlusCharInputStream& s, DOM::Document& docNode);
}



#endif
