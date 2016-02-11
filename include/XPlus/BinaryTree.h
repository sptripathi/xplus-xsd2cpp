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

#include <list>
#include <iostream>

#include "XPlus/AutoPtr.h"
#include "XPlus/XPlusObject.h"
#include "XPlus/Exception.h"

extern "C" {
#include <assert.h>
}

using namespace std;

namespace XPlus
{
  template <class T>
  struct TreeNode : public XPlus::XPlusObject
  {
    //AutoPtr<TreeNode<T> >     _parent;
    TreeNode<T>*              _parent;
    AutoPtr<TreeNode<T> >     _lc;
    AutoPtr<TreeNode<T> >     _rc;
    int                       _depth;  
    T                         _data;

    TreeNode(T data):
      XPlusObject("TreeNode"),
      _parent(NULL),
      _lc(NULL),
      _rc(NULL),
      _depth(0),
      _data(data)
    {
    }

    TreeNode(const TreeNode& node):
      XPlusObject("TreeNode"),
      _parent(node._parent),
      _lc(node._lc),
      _rc(node._rc),
      _depth(node._depth),
      _data(NULL)
    {
      if(!node._data.isNull()) {
        _data = node._data->clone();
      }
    }

    virtual ~TreeNode()
    {
      //cout << "~TreeNode()" << endl;
    }

    virtual TreeNode* clone() const {
      return new TreeNode(*this);
    }

    void print() const
    {
      cout << "_depth:" << _depth 
        << " _data:" << _data << endl;
    }

    inline bool isLeaf() const {
      return (_lc.isNull() && _rc.isNull());
    }
    
    inline bool hasOneChild() const {
      return  ( 
                (_lc.isNull() && !_rc.isNull()) ||
                (!_lc.isNull() && _rc.isNull())
              );
    }

    inline bool isRoot() const {
      return (_depth==0);
    }

    inline bool isLeftChild() const {
      return ( (_parent != NULL) && (_parent->_lc.get() == this) );
    }
    
    inline bool isRightChild() const {
      return (!_parent.isNull() && (_parent->_rc.get() == this) );
    }
    
    AutoPtr<TreeNode<T> >  oneChild() const 
    {
      if(!this->hasOneChild()) {
        return NULL;
      }
      AutoPtr<TreeNode<T> > node = ( _lc.isNull() ? _rc : _lc ); 
      return node;
    }

    AutoPtr<TreeNode<T> > addLeft(AutoPtr<TreeNode<T> >& node)
    {
      if(this->_lc.isNull())
      {
        node->_depth = this->_depth + 1;
        node->_parent = this;
        this->_lc = node;
        return node;
      }
      throw XPlus::NullPointerException("addLeft: lc already present");
    }

    AutoPtr<TreeNode<T> > addLeft(T data)
    {
      AutoPtr<TreeNode<T> > node = new TreeNode<T>(data); 
      return this->addLeft(node);
    }

    AutoPtr<TreeNode<T> > addRight(AutoPtr<TreeNode<T> >& node) 
    {
      if(this->_rc.isNull()) 
      {
        node->_depth = this->_depth + 1;
        node->_parent = this;
        this->_rc = node;
        return node;
      }
      throw XPlus::NullPointerException("addRight: rc already present");
    }

    AutoPtr<TreeNode<T> > addRight(T& data)
    {
      AutoPtr<TreeNode<T> > node = new TreeNode<T>(data); 
      return this->addRight(node);
    }

  };

  //TODO: add copy constructor to BinaryTree
  template <class T>
    class BinaryTree //: public XPlus::XPlusObject 
  {
    public:
      typedef AutoPtr<TreeNode<T> > TreeNodePtr;
      typedef TreeNode<T>* TreeNodeP;

      BinaryTree():
      //XPlusObject("BinaryTree"),
        _root(NULL)
    {
    }

      BinaryTree(const BinaryTree& ref):
      //XPlusObject("BinaryTree"),
        _root(NULL)
    {
      copyTree(ref);
    }

      virtual ~BinaryTree()  {}

      bool isAtRoot() const 
      {
        if(_root && _root->_lc.isNull() && _root->_rc.isNull()) {
          return true;
        }
        return false;
      }

      TreeNodePtr getFirstOrderLeaf(TreeNodePtr& node)
      {
        if(!node->_lc.isNull()) {
          return getFirstOrderLeaf(node->_lc);
        }
        else if(!node->_rc.isNull()) {
          return getFirstOrderLeaf(node->_rc);
        }

        return node;
      }

      TreeNodePtr getLastOrderLeaf(TreeNodePtr& node)
      {
        if(!node->_rc.isNull()) {
          return getLastOrderLeaf(node->_rc);
        }
        else if(!node->_lc.isNull()) {
          return getLastOrderLeaf(node->_lc);
        }

        return node;
      }

      TreeNodePtr removeNode(TreeNodePtr& node)
      {
        TreeNodePtr parentNode = node->_parent;
        if(parentNode.isNull()) 
        {
          assert(node->_depth == 0); // assert that node is root
          _root = NULL;
        }
        else
        {
          if(parentNode->_lc.get() == node.get()) {
            parentNode->_lc = NULL;
          }
          else if(parentNode->_rc.get() == node.get()) {
            parentNode->_rc = NULL;
          }
          else {
            // logical error
            throw XPlus::NullPointerException("removeNode: logical error");
          }
        }

        //setup leaves:
        // 1. remove leaves of this node
        // 2. add parentNode as leaf if parent has no child
        TreeNodePtr fol = getFirstOrderLeaf(node);
        TreeNodePtr lol = getLastOrderLeaf(node);
        typename std::list<TreeNodePtr>::iterator citBegin = find(_leaves.begin(), _leaves.end(), fol);
        typename std::list<TreeNodePtr>::iterator citEnd = find(_leaves.begin(), _leaves.end(), lol);
        if( (citBegin == _leaves.end()) || (citEnd == _leaves.end()) ) {
          // logical error
          throw XPlus::NullPointerException("removeNode: logical error");
        }
        if(!parentNode.isNull() && parentNode->isLeaf()) {
          _leaves.insert(citBegin, parentNode);
        }
        _leaves.erase(citBegin, ++citEnd);
        node->_parent = NULL;
        return node;
      }

      // useful when you want to create a tree of nodes of a type
      // derived from TreeNode
      TreeNodePtr addRoot(TreeNodePtr root)
      {
        if(_root.isNull())
        {
          _root = root; 
          addNodeAsLeaf(_root);
          return _root;
        }
        throw XPlus::NullPointerException("addRoot: root already present");
      }

      TreeNodePtr addRoot(T data) 
      {
        TreeNodePtr root = new TreeNode<T>(data); 
        return this->addRoot(root);
      }
      
      TreeNodePtr addLeft(TreeNodePtr parentNode, TreeNodePtr& node)
      {
        if(!parentNode.isNull() && !node.isNull())
        {
          bool parentWasLeaf = parentNode->isLeaf();
          node = parentNode->addLeft(node);
          if(!node.isNull())
          {
            if(parentWasLeaf) {
              updateLeavesOnParentGettingChild(parentNode, node);
            }
            else {
              assert(!parentNode->_rc.isNull()); 
              addNodeAsLeafAlongAnotherLeafNode(parentNode->_rc, node, true);
            }
          }
          return node;
        }
        throw XPlus::NullPointerException("addLeft failed");
      }
      
      TreeNodePtr addLeft(TreeNodePtr parentNode, T data)
      {
        TreeNodePtr node = new TreeNode<T>(data); 
        return this->addLeft(parentNode, node);
      }

      TreeNodePtr addRight(TreeNodePtr parentNode, TreeNodePtr& node) 
      {
        if(!parentNode.isNull() && !node.isNull())
        {
          bool parentWasLeaf = parentNode->isLeaf();
          node = parentNode->addRight(node); 
          if(!node.isNull())
          {
            if(parentWasLeaf) {
              updateLeavesOnParentGettingChild(parentNode, node);
            }
            else {
              assert(!parentNode->_lc.isNull()); 
              addNodeAsLeafAlongAnotherLeafNode(parentNode->_lc, node, false);
            }
          }
          return node;
        }
        throw XPlus::NullPointerException("addLeft failed");
      }
      
      TreeNodePtr addRight(TreeNodePtr parentNode, T data) 
      {
        TreeNodePtr node = new TreeNode<T>(data); 
        return this->addRight(parentNode, node);
      }

      inline const TreeNodePtr& getRoot() const {
        return _root;  
      }
      
      inline const list<TreeNodePtr>& getLeaves() const {
        return _leaves;  
      }

      void debugPrintLeaves(ostream& ostr) const 
      {
        typename std::list<TreeNodePtr>::const_iterator cit = _leaves.begin();
        ostr << "leaves: size=" << _leaves.size() << endl;
        for(; cit!=_leaves.end(); cit++)
        {
          const TreeNodePtr& mynode = *cit;
          if(!mynode.isNull()) {
            ostr << "self ptr:" << mynode.get() << endl;
            ostr << "depth:" << mynode->_depth << endl;
            ostr << "parent ptr:" << mynode->_parent.get() << endl;
            ostr << "data:" << mynode->_data << endl;
          }
          else {
            ostr << "data: (NULL)"  << endl;
          }
        }
      }

      
     void copyTree(const BinaryTree& ref)
     {
       _root = copyTreeNodes(ref._root);
       updateLeavesAfresh(_root);
       /*
      cout << "***********************************************"
        << " leaves size:" << _leaves.size() 
        << " ref-leaves size:" << ref.getLeaves().size() << endl;
        */
      /*
      typename std::list<TreeNodePtr>::const_iterator cit = _leaves.begin();
      for(; cit!=_leaves.end(); cit++)
      {
        TreeNodePtr mynode = *cit;
        if(!mynode.isNull()) {
          mynode->print();
        }
      }
      */
    }

    virtual BinaryTree* clone() const {
      return new BinaryTree(*this);
    }

    protected:
      TreeNodePtr          _root;
      list<TreeNodePtr>    _leaves;

      //postorder traverse
      void updateLeavesAfresh(TreeNodePtr node)
      {
        if(!node->_lc.isNull()) {
          updateLeavesAfresh(node->_lc);
        }
        if(!node->_rc.isNull()) {
          updateLeavesAfresh(node->_rc);
        }
        if(node->isLeaf()) {
          _leaves.push_back(node);
        }
      }

      static TreeNodePtr copyTreeNodes(const TreeNodePtr& node)
      {
        if(node.isNull()) {
          return NULL;
        }

        TreeNodePtr copyNode = node->clone();
        if(!node->_lc.isNull()) {
          copyNode->_lc = copyTreeNodes(node->_lc);
          copyNode->_lc->_parent = copyNode;
        }
        if(!node->_rc.isNull()) {
          copyNode->_rc = copyTreeNodes(node->_rc);
          copyNode->_rc->_parent = copyNode;
        }
        return copyNode;
      }

      bool removeNodeFromLeaves(TreeNodePtr node) 
      {
        typename std::list<TreeNodePtr>::const_iterator cit = _leaves.begin();
        for(; cit!=_leaves.end(); cit++)
        {
          TreeNodePtr mynode = *cit;
          if(mynode.get() == node.get()) {
            _leaves.erase(cit); 
            return true;
          }
        }
        return false;
      }

      bool updateLeavesOnParentGettingChild(TreeNodePtr& parentNode, TreeNodePtr& childNode)
      {
        typename list<TreeNodePtr>::iterator cit = _leaves.begin();
        for(; cit!=_leaves.end(); cit++)
        {
          const TreeNodePtr& mynode = *cit;
          if(mynode.get() == parentNode.get()) 
          {
            _leaves.insert(cit, childNode); 
            _leaves.erase(cit); 
            return true;
          }
        }
        return false;
      }

      void addNodeAsLeaf(TreeNodePtr node)
      {
        _leaves.push_back(node);
      }


      bool addNodeAsLeafAlongAnotherLeafNode(TreeNodePtr& referenceNode, TreeNodePtr& node, bool before=true)
      {
        if(referenceNode.isNull()) {
          addNodeAsLeaf(node);
          return true;
        }

        typename list<TreeNodePtr>::iterator cit = _leaves.begin();
        for(; cit!=_leaves.end(); cit++)
        {
          const TreeNodePtr& mynode = *cit;
          if(mynode.get() == referenceNode.get()) 
          {
            typename list<TreeNodePtr>::iterator citNew = (before ? cit : ++cit);
            _leaves.insert(citNew, node);
            return true;
          }
        }
        return false;
      }

  };

}
