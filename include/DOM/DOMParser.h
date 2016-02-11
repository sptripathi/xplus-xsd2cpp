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

#ifndef __DOM_ALL_INC_H__
#define __DOM_ALL_INC_H__

#include "DOM/ExpatParser.h"
#include "DOM/DOMAllInc.h"
#include "DOM/Stack.h"

using namespace std;
using namespace DOM;

class DOMParser : public ExpatParser
{
  protected:
    Document*                 _docNode;

    DOMString                 _cdataBuffer;
    bool                      _cdataInProgress;

  public:

    DOMParser(Document* docNode=NULL):
      _docNode(docNode),
      _cdataBuffer(""),
      _cdataInProgress(false)
  {
    if(_docNode)
      _docNode->stateful(true);
  }
    
    virtual ~DOMParser() { }

    inline const Document* getDocument() const {
      return _docNode;
    }

    void parseXmlFileDOM(string filePath);
    void printTreePreOrder(const Node *node, int depth);
    void printTree();


    void onXmlDecl(void            *userData,
                 const DOMString  *version,
                 const DOMString  *encoding,
                 int             standalone);
    void onElementStart(void *userData, NodeNSTriplet nsTriplet, vector<AttributeInfo> attrVec); 
    void onAttribute(void *userData, AttributeInfo attrInfo);
    void onElementEnd(void *userData, NodeNSTriplet nsTriplet);
    void onNamespaceStart(void *userData, 
        const DOMString* prefix, 
        const DOMString* uri);
    void onNamespaceEnd(void *userData, const DOMString* prefix);
    void onDocTypeStart( void  *userData,
        const DOMString* doctypeName,
        const DOMString* sysid,
        const DOMString* pubid,
        int has_internal_subset);
    void onDocTypeEnd(void *userData);
    void onCDATAStart(void *userData);
    void onCDATAEnd(void *userData);
    void onPI( void *userData,
        const DOMString* target,
        const DOMString* data);
    void onCharacterData(void *userData, const DOMString*  strData);
    void onComment(void *userData, const DOMString*  data);
    
    void onDocumentStart(void *userData);
    void onDocumentEnd(void *userData);
    void createAccumulatedTextNode();

    inline void beginOfCDATASection() {
      _cdataInProgress = true;
    }
    inline void endOfCDATASection() {
      _cdataInProgress = false;
      resetCDATABuffer();
    }
    inline bool isCDATAInProgress() {
      return _cdataInProgress;
    }

    inline void resetCDATABuffer() {
      _cdataBuffer = "";
    }
    inline void addCDATABuffer(DOMString str) {
      _cdataBuffer += str;
    }
    inline DOMString getCDATABuffer() {
      return _cdataBuffer;
    }
};
#endif
