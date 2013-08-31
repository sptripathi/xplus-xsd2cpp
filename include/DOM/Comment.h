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

#ifndef __COMMENT_H__
#define __COMMENT_H__

#include "DOM/DOMCommonInc.h"
#include "DOM/CharacterData.h"

namespace DOM
{
  class Comment : public CharacterData
  {
    public:
    Comment(
      DOMString* nodeValue,
      Document* ownerDocument=NULL,
      Node* parentNode=NULL);

    virtual ~Comment() {}
  };
}

#endif
