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

#ifndef __LLIST_H__
#define __LLIST_H__

#include <vector>
#include <sstream>
#include <map>

#include "Exception.h"
#include "XPlus/XPlusObject.h"
#include "XPlus/AutoPtr.h"

using namespace std;

// TODO NB:
// 1. findNode disabled: find way to verify that the supplied "node"
//    arg claimed to be part of list is actually part of the list
// 2. removeNode : decide about retaining this functionality
//

namespace XPlus
{
  // 
  // The T * is a pointer-to-class. Such a class should implement folowing public methods:
  //  - setPreviousSibling(T * ptrNode)   : sets the previous-sibling of self to ptrNode
  //  - getPreviousSibling(T * ptrNode)   : returns the previous-sibling of self
  //  - setNextSibling(T * ptrNode)       : sets the next-sibling of self to ptrNode
  //  - getNextSibling(T * ptrNode)       : returns the next-sibling of self
  //
  template<class T> class LList : public virtual XPlus::XPlusObject
  {
    public:
      typedef AutoPtr<T> TPtr;

      LList():
        XPlusObject("LList"),
        _head(NULL),
        _tail(NULL),
        _size(0)
    {
    }

      ~LList()
      {
        /*
        cout << "{ destructing LList:"  << this << " map size:" << _nodesMap.size() << " head:" << _head << " tail:" <<  _tail << endl;
        this->print();
        cout << "} destructing LList:" << this << " END" << endl;
        */
        
        typename map<TPtr, bool>::iterator it = _nodesMap.begin();
        for( ; it != _nodesMap.end(); ++it ) {
          TPtr tptr = it->first;
          tptr->removedFromParentList(true);
        }
      }

      void print()
      {
        typename map<TPtr, bool>::iterator it = _nodesMap.begin();
        for( ; it != _nodesMap.end(); ++it ) {
          cout << "   nodeMap node:" << it->first << " name:" << *it->first->getNodeName() << endl;
        }
      }


      T* item(unsigned long index) const
      {
        ostringstream error;
        error << "Accessed LList at index:" << index << " while LList size:" << this->getLength();
        if(index > this->getLength()-1) {
          throw XPlus::IndexOutOfBoundsException(error.str());
        }
        unsigned int idx =0;
        for( T * node=_head; node != (T *)NULL; node=node->getNextSibling(), idx++)
        {
          if(idx == index) {
            return node;
          }
        }
        return NULL;
      }

      unsigned long getLength() const {
        return _size;
      }

      /*****************          impl apis    ******************/


      T* front() const 
      {
        return _head;
      }

      T* back() const 
      {
        return _tail;
      }

      T* insertBack(T * node) 
      {
        T * oldLastNode = _tail;
        insertBetween(node, oldLastNode, NULL);
        return node;
      }

      T* insertFront(T * node) 
      {
        T * oldFirstNode = _head;
        insertBetween(node, NULL, oldFirstNode);
        return node;
      }

      T* insertAt(T* node, unsigned int pos) 
      {
        if(pos > this->getLength()) 
        {
          ostringstream error;
          error << "Accessed LList at index:" << pos 
            << " while LList size:" << this->getLength();
          if(pos > this->getLength()-1) {
            throw XPlus::IndexOutOfBoundsException(error.str());
          }
        }
        else if(pos == this->getLength()) {
          return this->insertBack(node);
        }
        // if(pos < this->getLength())
        else 
        {
          T *prevNode = ((pos>0)? this->item(pos-1) : NULL);
          T *nextNode = this->item(pos);
          return this->insertBetween(node, prevNode, nextNode);
        }
      }


      /* Inserts the node newNode before the existing Node node refNode.
         If refNode is null, insert newNode at the end of the list of
         Nodes. If newNode is a DocumentFragment object, all of its
         Nodes are inserted, in the same order, before refNode. 
         If the newNode is already in the tree, it is first removed. 
       */
      T* insertBefore(T * newNode, T * refNode)
      {
        if(!newNode) {
          return newNode;
        }
        else if(!refNode) {
          //refNode NULL: not specified by DOM spec ??
          return NULL;
        }
        else 
        {
          // findNode disabled in the interest of perf
          //T * listRefNode = findNode(refNode);
          T * listRefNode = refNode;

          if(listRefNode)
          {
            T * prevNode = listRefNode->getPreviousSibling();

            // disabled in the interest of perf
            //removeNode(newNode);

            return insertBetween(newNode, prevNode, refNode);
          }
          else
          {
            //refNode not in list: not specified by DOM spec ??
            return NULL;
          }

        }
        //TODO: handle doc-fragment
        return NULL;
      }

      T* insertAfter(T * newNode, T * refNode)
      {
        if(!newNode) {
          return newNode;
        }
        else if(!refNode) {
          //refNode NULL: not specified by DOM spec ??
          return NULL;
        }
        else 
        {
          // findNode disabled in the interest of perf
          //T * listRefNode = findNode(refNode);
          T * listRefNode = refNode;
          if(listRefNode)
          {
            T * nextNode = listRefNode->getNextSibling();

            // disabled in the interest of perf
            //removeNode(newNode);

            return insertBetween(newNode, listRefNode, nextNode);
          }
          else
          {
            //refNode not in list: not specified by DOM spec ??
            return NULL;
          }

        }
        //TODO: handle doc-fragment
        return NULL;
      }



      /*
         Replaces the Node node oldNode with newNode in the list of Nodes, and returns the oldNode node.
         If newNode is a DocumentFragment object, oldNode is replaced by all of the DocumentFragment Noderen, which are inserted in the same order. If the newNode is already in the tree, it is first removed.
       */
      T* replaceNode(T * newNode, T * oldNode)
      {
        if(!newNode) {
          return newNode;
        }
        else if(!oldNode) {
          //oldNode NULL: not specified by DOM spec ??
          return NULL;
        }
        else
        {
          // findNode disabled in the interest of perf
          //T * listOldNode = findNode(oldNode);
          T * listOldNode = oldNode;
          if(listOldNode)
          {
            T * prevNode = listOldNode->getPreviousSibling();
            T * nextNode = listOldNode->getNextSibling();
            /*
            // disabled in the interest of perf
            removeNode(listOldNode);
            removeNode(newNode);
             */
            return insertBetween(newNode, prevNode, nextNode);
          }
          else
          {
            //oldNode not in list: not specified by DOM spec ??
            return NULL;
          }

        }

        //TODO: handle doc-fragment
        return newNode; 
      }


      T* findNode(T * refNode)
      {
        if(!refNode) {
          return NULL;
        }
        //  why duplicate ? Because otherwise, refNode is destructed after the call because ref count goes 0->1->0
        // This would need to change if AutoPtr/XPlusObject behaviour is changed
        refNode->duplicate();
        bool bDontFree = refNode->dontFree();
        refNode->dontFree(true);
        typename map<TPtr, bool>::iterator it = _nodesMap.find(refNode);
        refNode->dontFree(bDontFree);
        if(it == _nodesMap.end()) {
          return NULL;
        }

        return const_cast<T *>(it->first.get());
      }


      void markHead(T * node)
      {
        _head = node;
      }

      void markTail(T * node)
      {
        _tail = node;
      }

      T* insertBetween(T * node, T * prevNode, T * nextNode)
      {
        if(!node) {
          return node;
        }

        node->setNextSibling(nextNode);
        node->setPreviousSibling(prevNode);

        if(prevNode) {
          prevNode->setNextSibling(node);
        }
        else {
          markHead(node);
        }

        if(nextNode) {
          nextNode->setPreviousSibling(node);
        }
        else {
          markTail(node);
        }

        _nodesMap[AutoPtr<T>(node)] = true;
        _size ++;
        return node;
      }

      void removeNode(T * refNode)
      {
        //cout << "LList::removeNode called on: "  << *refNode->getNodeName() << endl;
        T* node = findNode(refNode);
        if(!node) {
          cerr << "didnt find the node to remove" << endl;
          return ;
        }

        T * prevNode = node->getPreviousSibling();
        T * nextNode = node->getNextSibling();
        if(prevNode) {
          prevNode->setNextSibling(nextNode);
        }
        if(nextNode) {
          nextNode->setPreviousSibling(prevNode);
        }
        
        if(_head == node) {
          _head = NULL;
        }
        if(_tail == node) {
          _tail = NULL;
        }

        _size--;
        node->setNextSibling(NULL);
        node->setPreviousSibling(NULL);

        node->duplicate();
        bool bDontFree = refNode->dontFree();
        refNode->dontFree(true);
        typename map<TPtr, bool>::iterator it = _nodesMap.find(node);
        refNode->dontFree(bDontFree);
          
        refNode->removedFromParentList(true);
        if(it != _nodesMap.end()) {
          //node->printRefCnt();
          //cout << " ***  erasing node from map. name:" << *node->getNodeName() 
          //<< " dontFree:" << it->first->dontFree() << endl;
          _nodesMap.erase(it); 
        }
        //return node;
      }

    protected:

      T*                    _head;
      T*                    _tail;
      unsigned int          _size;
      map<TPtr, bool>        _nodesMap;
  };

}

#endif
