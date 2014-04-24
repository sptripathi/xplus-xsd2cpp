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

#ifndef __TEXT_ENCODING_H__
#define __TEXT_ENCODING_H__

#include <string>

using namespace std;

namespace XPlus
{

  #define MAX_ENC 5
  class TextEncoding
  {
    public:

      enum eTextEncoding
      {
        ASCII   = 0,
        ISO_8859_1,
        UTF_8,
        UNSPECIFIED=1000,
        UNKNOWN
      };

      //constructor
      TextEncoding(eTextEncoding enc=UNSPECIFIED):
        _encoding(enc)
        {
        }
      
      TextEncoding(string encStr)
      {
        _encoding = stringToEnum(encStr);
      }

      inline eTextEncoding toEnum() const {
        return _encoding;
      }
      
      inline const string toString() const {
        return enumToString(_encoding);
      }

      static string enumToString(eTextEncoding enc);
      static eTextEncoding stringToEnum(string encStr);

      private:

      eTextEncoding _encoding;
      static string  s_encodingStr[MAX_ENC];
  };
}

#endif
