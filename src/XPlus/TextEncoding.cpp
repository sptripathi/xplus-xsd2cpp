// This file is part of XmlPlus package
// 
// Copyright (C)   2010-2013   Satya Prakash Tripathi
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


#include "XPlus/TextEncoding.h"
#include <strings.h>

namespace XPlus
{
  string  TextEncoding::s_encodingStr[] =
  {
    "ASCII",
    "ISO-8859-1",
    "UTF-8",
    ""
    "unknown"
  };

  string TextEncoding::enumToString(TextEncoding::eTextEncoding enc)
  {
    int enc2 = static_cast<int>(enc);
    int enc3 = ((enc2 >= MAX_ENC) ? MAX_ENC : enc2);
    return s_encodingStr[enc3]; 
  }

  TextEncoding::eTextEncoding TextEncoding::stringToEnum(string encStr)
  {
    int matchedIdx = MAX_ENC;
    for(int i=0; i<MAX_ENC; i++)
    {
      if( strcasecmp(s_encodingStr[i].c_str(), encStr.c_str()) == 0) {
        matchedIdx = i;
        break;
      }
    }
    TextEncoding::eTextEncoding enc = static_cast<TextEncoding::eTextEncoding>(matchedIdx);
    return enc;
  }
}

