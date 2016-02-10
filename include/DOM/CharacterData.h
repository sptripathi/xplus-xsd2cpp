// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013 Satya Prakash Tripathi
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
