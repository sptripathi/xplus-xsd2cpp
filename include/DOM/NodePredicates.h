#ifndef __NODE_FILTER_H__
#define __NODE_FILTER_H__

#include <list>
#include <vector>
#include "DOM/DOMAllInc.h"
#include "DOM/NodePredicates.h"


namespace DOM
{
  class NodePredicates
  {
    protected:
      DOMStringPtr   _nameToEquate;
      Node::NodeType _typeToEquate;
      //... add more

    public:
      NodePredicates();

      virtual ~NodePredicates() {}

    inline NodePredicates& nameToEquate(DOMString* nodeName) {
      _nameToEquate = nodeName;
      return *this;
    }
    
    inline const DOMString* nameToEquate() {
      return _nameToEquate;
    }
    
    inline NodePredicates& typeToEquate(const Node::NodeType nodeType) {
      _typeToEquate = nodeType;
      return *this;
    }
      
    inline const Node::NodeType typeToEquate() {
      return _typeToEquate;
    }

    bool evaluate(Node* nodePtr);
    bool evaluateNameEquality(Node* nodePtr);
    bool evaluateTypeEquality(Node* nodePtr);
  };
}
#endif
