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
    Document* _docNode;

    XmlDecl   _docXmlDecl;
    // FIXME: may not ne needed, remove later
    Stack<NodeNSTriplet> _parseStack;
    DOMString _elemTextBuffer;

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
    void onElementStart(void *userData, NodeNSTriplet nsTriplet); 
    void onAttribute(void *userData, NodeNSTriplet nsTriplet,
        const DOMString* value);
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
};
#endif
