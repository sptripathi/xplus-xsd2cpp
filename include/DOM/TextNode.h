#ifndef __DOM_TEXT_NODE_H__
#define __DOM_TEXT_NODE_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/CharacterData.h"

namespace DOM
{
  class TextNode : public CharacterData
  {
  public:
    TextNode(
          DOMString* nodeValue,
          Document* ownerDocument=NULL,
          Node* parentNode=NULL,
          Node* prevSibling=NULL
          );
    virtual ~TextNode() {}
    
    virtual TextNodeP splitText(unsigned long offset); // throws();

  };

}
#endif

