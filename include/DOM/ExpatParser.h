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

#ifndef __EXPATPARSER_H__
#define __EXPATPARSER_H__


#include <iostream>
#include <vector>

extern "C" {
#include <stdio.h>
#include "expat.h"
}

#if defined(__amigaos__) && defined(__USE_INLINE__)
extern "C" {
#include <proto/expat.h>
}
#endif

#include "DOM/XMLParser.h"
#include "DOM/Node.h" /* TODO: replace his include to file which has NodeNSTriplet */


#ifdef XML_LARGE_SIZE
#if defined(XML_USE_MSC_EXTENSIONS) && _MSC_VER < 1400
#define XML_FMT_INT_MOD "I64"
#else
#define XML_FMT_INT_MOD "ll"
#endif
#else
#define XML_FMT_INT_MOD "l"
#endif

#define BUFFSIZE        8192

using namespace std;

class ExpatParser;

struct ParserUserData {
  ExpatParser *parser;
  void *userData;

  ParserUserData():
    parser(NULL),
    userData(NULL)
  {
  }
};

namespace ExpatCB 
{
  void onElementStart(void *userData, 
                      const XML_Char *name, 
                      const XML_Char **atts);

  void onElementEnd(void *userData, 
                    const XML_Char *name);
  void onNamespaceStart(void *userData, 
                        const XML_Char *prefix,
                        const XML_Char *uri);
  void onNamespaceEnd(void *userData, 
                      const XML_Char *prefix);
  void onDocTypeStart( void  *userData,
                       const XML_Char *doctypeName,
                       const XML_Char *sysid,
                       const XML_Char *pubid,
                       int has_internal_subset);
  void onDocTypeEnd(void *userData);
  void onCDATAStart(void *userData);
  void onCDATAEnd(void *userData);
  void onPI( void *userData,
             const XML_Char *target,
             const XML_Char *data);

}


// C++ Wrapper around expat C parser
class ExpatParser : public DOM::XMLParser
{
private:
  XML_Parser _expatParser;

protected:
  ParserUserData *_parserUserData;

public:
 
  ExpatParser();
  virtual ~ExpatParser();

  //concrete
  virtual void setUserData(void *userData);
  virtual bool parseXmlFile(string filePath);
  virtual bool parseInputStream(istream& is);
  
  virtual void onDocumentStart(void *userData) = 0;
  virtual void onDocumentEnd(void *userData) = 0;
  virtual void onXmlDecl(void            *userData,
                 const DOM::DOMString  *version,
                 const DOM::DOMString  *encoding,
                 int             standalone)=0;
  virtual void onElementStart(void *userData, DOM::NodeNSTriplet nsTriplet, vector<DOM::AttributeInfo> attrVec)=0; 
  virtual void onAttribute(void *userData, DOM::AttributeInfo attrInfo) = 0;

  virtual void onElementEnd(void *userData, DOM::NodeNSTriplet nsTriplet)=0; 
  virtual void onNamespaceStart(void *userData, const DOM::DOMString* prefix,
                                const DOM::DOMString* uri) =0;
  virtual void onNamespaceEnd(void *userData, const DOM::DOMString* prefix) =0;
  virtual void onDocTypeStart( void  *userData,
                       const DOM::DOMString* doctypeName,
                       const DOM::DOMString* sysid,
                       const DOM::DOMString* pubid,
                       int has_internal_subset) =0;
  virtual void onDocTypeEnd(void *userData) = 0;
  virtual void onCDATAStart(void *userData) = 0;
  virtual void onCDATAEnd(void *userData) = 0;
  virtual void onPI( void *userData,
                    const DOM::DOMString* target,
                    const DOM::DOMString* data) = 0;
  virtual void onCharacterData(void *userData, const DOM::DOMString* charData) =0;
  virtual void onComment(void *userData, const DOM::DOMString* data) =0;

  virtual int getCurentLineNum();
  virtual int getCurentColumnNum();
};

#endif
