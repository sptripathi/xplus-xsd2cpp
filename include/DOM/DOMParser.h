// This file is part of XmlPlus package
// 
// Copyright (C)   2010   Satya Prakash Tripathi
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

    DOMString                 _cdataBufferOnDocBuild;
    bool                      _cdataInProgress;

  public:

    DOMParser(Document* docNode=NULL):
      _docNode(docNode)
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

    inline bool beginOfCDATASection() {
      _cdataInProgress = true;
    }
    inline bool endOfCDATASection() {
      _cdataInProgress = false;
      resetCDATABufferOnDocBuild();
    }
    inline bool isCDATAInProgress() {
      return _cdataInProgress;
    }

    inline void resetCDATABufferOnDocBuild() {
      _cdataBufferOnDocBuild = "";
    }
    inline void addCDATABufferOnDocBuild(DOMString str) {
      _cdataBufferOnDocBuild += str;
    }
    inline DOMString getCDATABufferOnDocBuild() {
      return _cdataBufferOnDocBuild;
    }
};
#endif
