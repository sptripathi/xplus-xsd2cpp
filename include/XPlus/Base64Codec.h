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

#ifndef __XPLUS_BASE64CODEC_H__
#define __XPLUS_BASE64CODEC_H__

#include <string>
#include "XPlus/XPlusObject.h"

using namespace std;

namespace XPlus
{
  class Base64Codec
  {
    public:
      Base64Codec();

      string encode(string inputBuffer);
      string decode(const string& input);

    private:

      //Lookup table for encoding
      //If you want to use an alternate alphabet, change the characters here
      string _encodeLookup;

      const static char _padChar;
  };

}

#endif
