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
