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

#ifndef __FUNCTOR_H__
#define __FUNCTOR_H__

#include "XPlus/AutoPtr.h"
#include "XPlus/XPlusObject.h"

namespace XPlus
{
  using namespace std;

  // FIXME: make XPlusObject as base
  template <class R, class A> struct unary_function_base : public unary_function<A,R>, public XPlus::XPlusObject
  {
    unary_function_base():
      XPlusObject("unary_function_base")
      {
      }

    virtual R operator()(A& arg)=0;
  };


  //template <class R, class T, class A> class object_unary_mem_fun_t : public unary_function<A,R>
  template <class R, class T, class A> class object_unary_mem_fun_t : public unary_function_base<R,A>
  {
    private:
      T*    _ptrObj;
      R (T::*_ptrNoArgFunc)(A& arg);

    public:

      explicit object_unary_mem_fun_t(T *ptrObj, R (T::*ptrNoArgFunc)(A& arg)):
        _ptrObj(ptrObj),
        _ptrNoArgFunc(ptrNoArgFunc)
    {
    }

      R operator()(A& arg)
      {
        if(_ptrObj) {
          return (_ptrObj->*_ptrNoArgFunc)(arg);
        }
        else {
          //TODO: throw NullPointerException
        }
      }
  };


  template <class R> struct noargs_function_base : public unary_function<void,R>, public XPlus::XPlusObject
  {
    noargs_function_base():
      XPlusObject("noargs_function_base")
      {
      }
    virtual R operator()()=0;

  };


  template <class R, class T> class object_noargs_mem_fun_t : public noargs_function_base<R>
  {
    private:
      T*    _ptrObj;
      R (T::*_ptrNoArgFunc)();

    public:

      explicit object_noargs_mem_fun_t(T *ptrObj, R (T::*ptrNoArgFunc)()):
        _ptrObj(ptrObj),
        _ptrNoArgFunc(ptrNoArgFunc)
    {
    }

      void ptrObj(T*& ptrObj) {
        _ptrObj = ptrObj;
      }

      R operator()()
      {
        if(_ptrObj && _ptrNoArgFunc) {
          return (_ptrObj->*_ptrNoArgFunc)();
        }
        else {
          //TODO: throw NullPointerException
        }
      }
  };


  template<class R, class T, class A> object_unary_mem_fun_t<R,T,A> object_unary_mem_fun(T *ptrObj, R (T::*ptrNoArgFunc)(A arg))
  {
    return object_unary_mem_fun_t<R,T,A>(ptrObj, ptrNoArgFunc);
  }


  template<class R, class T> object_noargs_mem_fun_t<R,T> object_noargs_mem_fun(T *ptrObj, R (T::*ptrNoArgFunc)())
  {
    return object_noargs_mem_fun_t<R,T>(ptrObj, ptrNoArgFunc);
  }


#ifdef _MAIN2

  class B;

  class A {
    public:

      object_unary_mem_fun_t<int, B, int> *pFunctor;
      object_noargs_mem_fun_t<void, B> *pFunctor_noargs;

      void faa() 
      {
        cout << "A:faa " << (*pFunctor)(7) << endl;
        (*pFunctor_noargs)();
      }
  };


  class B : public A
  {
    public:
      B()
      {
        pFunctor        = new object_unary_mem_fun_t<int, B, int>(this, &B::foox);
        pFunctor_noargs = new object_noargs_mem_fun_t<void, B>(this, &B::foo);
      }

      void foo() {
        cout << "B::foo" << endl;
      }

      int foox(int x) {
        cout << "B::foox:" << x << endl;
        return x+1;
      }

      void baz() {
        A::faa();
      }
  };

  int main()
  {
    //test1
    cout << "\n test1" << endl;
    B b;
    b.baz();

    //test2
    cout << "\n test2" << endl;
    object_unary_mem_fun_t<int, B, int> callback_B_foox = object_unary_mem_fun(&b, &B::foox);
    callback_B_foox(10);
    object_noargs_mem_fun_t<void, B> callback_B_foo = object_noargs_mem_fun(&b, &B::foo);
    callback_B_foo();

    // test3
    cout << "\n test3" << endl;
    unary_function_base<int,int> *pCallback_B_foox = new object_unary_mem_fun_t<int, B, int>(&b, &B::foox);
    (*pCallback_B_foox)(20);
    noargs_function_base<void> *pCallback_B_foo = new object_noargs_mem_fun_t<void, B>(&b, &B::foo);
    (*pCallback_B_foo)();

    return 0;
  }
#endif

}

#endif

