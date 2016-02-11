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

#ifndef __LIST_H__
#define __LIST_H__

#include <list>
#include "Exception.h"

using namespace std;
namespace XPlus
{
  template<class T>
  class List : public list<T> 
  {
    public:

      const T& at(unsigned int idx) const 
      {
        if(idx >= this->size()) {
          throw XPlus::IndexOutOfBoundsException("IndexOutOfBoundsException");
        }

        unsigned int i=0;
        typename list<T>::const_iterator it = this->begin();
        for(; it != this->end(); ++it, ++i) 
        {
          if(i==idx) {
            return *it;
          }
        }
          
        throw IndexOutOfBoundsException("IndexOutOfBoundsException");
      }


      T& at(unsigned int idx) 
      {
        if(idx >= this->size()) {
          throw IndexOutOfBoundsException("IndexOutOfBoundsException");
        }

        unsigned int i=0;
        typename list<T>::iterator it = this->begin();
        for(; it != this->end(); ++it, ++i) 
        {
          if(i==idx) {
            return *it;
          }
        }
          
        throw IndexOutOfBoundsException("IndexOutOfBoundsException");
      }
      
      T& back() 
      {
        return list<T>::back();
      }
      
      const T& back() const
      {
        return list<T>::back();
      }

    protected:
  };


}// end namespace XPlus
#endif
