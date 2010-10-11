#ifndef __NAMED_NODE_MAP_H__
#define __NAMED_NODE_MAP_H__

#include <map>

#include "DOM/DOMCommonInc.h"

namespace DOM
{

  class NamedNodeMap : public std::map<DOMStringPtr, NodePtr>
  {
    protected:

    public:
      virtual ~NamedNodeMap() {}

      unsigned long length() const;
      virtual Node* item(unsigned long index);
      virtual const Node* item(unsigned long index) const;
      virtual Node* getNamedItem(DOMString* name);
      virtual Node* setNamedItem(Node* arg); // throws();
      virtual Node* removeNamedItem(DOMString* name); // throws();

      // Introduced in DOM Level 2:
      virtual Node* getNamedItemNS(DOMString* namespaceURI, DOMString* localName);
      virtual Node* setNamedItemNS(Node* arg); // throws();
      virtual Node* removeNamedItemNS(DOMString* namespaceURI,
          DOMString* localName); // throws();

      //impl apis
      void print() const;
  };
}

#endif
