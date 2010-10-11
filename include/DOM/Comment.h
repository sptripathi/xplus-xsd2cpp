#ifndef __COMMENT_H__
#define __COMMENT_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/CharacterData.h"

namespace DOM
{
  class Comment : public CharacterData
  {
    public:
    Comment(
      DOMString* nodeValue,
      Document* ownerDocument=NULL,
      Node* parentNode=NULL);

    virtual ~Comment() {}
  };
}

#endif
