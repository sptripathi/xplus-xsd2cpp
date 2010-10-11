#ifndef __DOM_CHARACTER_DATA_H__ 
#define __DOM_CHARACTER_DATA_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/Node.h"

namespace DOM
{
  class CharacterData : public Node 
  {

  protected:
	  //    DOMStringPtr _data;
        // raises(DOMException) on setting
        // raises(DOMException) on retrieval


  public:

    CharacterData(DOMString* nodeName,
          Node::NodeType nodeType, 
          DOMString* data,
          Document* ownerDocument=NULL,
          Node* parentNode=NULL,
          Node* prevSibling=NULL
          );
    
    virtual ~CharacterData() {}

    virtual const DOMString* getData() const {
      return getNodeValue();
    }

    virtual unsigned long getLength() const{
      if( getNodeValue() != (DOMStringP)NULL ) {
    	  return getNodeValue()->length();
      }
      return 0;
    }

    virtual DOMString* substringData(unsigned long offset,
                                    unsigned long count);//   throws();
    virtual void appendData(DOMString* arg);//      throws();
    virtual void insertData(unsigned long offset, 
                            DOMString* arg); // throws();
    virtual void deleteData(unsigned long offset, 
                            unsigned long count);// throws();
    virtual void replaceData(unsigned long offset, 
                             unsigned long count, 
                             DOMString* arg);// throws();
  };
}
#endif
