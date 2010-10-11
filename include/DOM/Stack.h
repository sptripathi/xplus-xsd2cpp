#ifndef __STACK_H__
#define __STACK_H__

#include <list>

template<class T>
class Stack 
{
  private:
    list<T> _list;
  
  public:
    
    void push(T obj) {
      _list.push_back(obj);
    }

    T pop() {
      T obj = _list.back();
      _list.pop_back();
      return obj;
    }

    T getNext() {
      return _list.back();
    }
};

#endif
