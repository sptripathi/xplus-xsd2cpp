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

#ifndef __NOTATION_H__
#define __NOTATION_H__

#include "DOM/DOMCommonInc.h"

namespace DOM
{
  class Notation
  {
  protected:
    const DOMStringPtr _publicId;
    const DOMStringPtr _systemId;

  public:

    virtual ~Notation() {}
    const DOMString* getPublicId() const {
      return _publicId;
    }

    const DOMString* getSystemId() const {
      return _systemId;
    }
  };
}

#endif
