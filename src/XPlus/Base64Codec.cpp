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
// *******************************************************************
// Implementation Note:
//
// This code is an adaptation from the original work available at:
// http://en.wikibooks.org/wiki/Algorithm_Implementation/Miscellaneous/Base64
// *******************************************************************
//

#include <iostream>
#include <string>
#include "XPlus/Exception.h"
#include "XPlus/UString.h"
#include "XPlus/Base64Codec.h"

using namespace std;

namespace XPlus
{

  const char Base64Codec::_padChar = '=';

  Base64Codec::Base64Codec():
    _encodeLookup()
  {
    _encodeLookup = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  }

  string Base64Codec::encode(string inputBuffer)
  {
    string encodedString;
    encodedString.reserve(((inputBuffer.size()/3) + (inputBuffer.size() % 3 > 0)) * 4);
    long temp;
    string::iterator cursor = inputBuffer.begin();
    for(size_t idx = 0; idx < inputBuffer.size()/3; idx++)
    {
      temp  = (*cursor++) << 16; //Convert to big endian
      temp += (*cursor++) << 8;
      temp += (*cursor++);
      encodedString.append(1,_encodeLookup[(temp & 0x00FC0000) >> 18]);
      encodedString.append(1,_encodeLookup[(temp & 0x0003F000) >> 12]);
      encodedString.append(1,_encodeLookup[(temp & 0x00000FC0) >> 6 ]);
      encodedString.append(1,_encodeLookup[(temp & 0x0000003F)      ]);
    }
    switch(inputBuffer.size() % 3)
    {
      case 1:
        temp  = (*cursor++) << 16; //Convert to big endian
        encodedString.append(1,_encodeLookup[(temp & 0x00FC0000) >> 18]);
        encodedString.append(1,_encodeLookup[(temp & 0x0003F000) >> 12]);
        encodedString.append(2,_padChar);
        break;
      case 2:
        temp  = (*cursor++) << 16; //Convert to big endian
        temp += (*cursor++) << 8;
        encodedString.append(1,_encodeLookup[(temp & 0x00FC0000) >> 18]);
        encodedString.append(1,_encodeLookup[(temp & 0x0003F000) >> 12]);
        encodedString.append(1,_encodeLookup[(temp & 0x00000FC0) >> 6 ]);
        encodedString.append(1,_padChar);
        break;
    }
    return encodedString;
  }

  string Base64Codec::decode(const string& inStr)
  {
    UString ustr = inStr;
    ustr.removeChars(UTF8FNS::isWhiteSpaceChar);
    string input = ustr;

    if (input.length() % 4)
    {
      ostringstream oss;
      oss << "Base64Codec::decode failed." << endl
          << "A Base64 encoded string when stripped-off of whitespaces"
             " should have a length, multiple of 4." << endl
          << "Violated by input string:[" << inStr << "]" << endl;
      throw XPlus::Exception(oss.str());
    }

    size_t padding = 0;
    if (input.length())
    {
      if (input[input.length()-1] == _padChar)
        padding++;
      if (input[input.length()-2] == _padChar)
        padding++;
    }
    //Setup a vector to hold the result
    string decodedBytes;
    decodedBytes.reserve(((input.length()/4)*3) - padding);
    long temp=0; //Holds decoded quanta
    string::const_iterator cursor = input.begin();
    while (cursor < input.end())
    {
      for (size_t quantumPosition = 0; quantumPosition < 4; quantumPosition++)
      {
        temp <<= 6;
        if       (*cursor >= 0x41 && *cursor <= 0x5A) // This area will need tweaking if
          temp |= *cursor - 0x41;                        // you are using an alternate alphabet
        else if  (*cursor >= 0x61 && *cursor <= 0x7A)
          temp |= *cursor - 0x47;
        else if  (*cursor >= 0x30 && *cursor <= 0x39)
          temp |= *cursor + 0x04;
        else if  (*cursor == 0x2B)
          temp |= 0x3E; //change to 0x2D for URL alphabet
        else if  (*cursor == 0x2F)
          temp |= 0x3F; //change to 0x5F for URL alphabet
        else if  (*cursor == _padChar) //pad
        {
          switch( input.end() - cursor )
          {
            case 1: //One pad character
              decodedBytes.push_back((temp >> 16) & 0x000000FF);
              decodedBytes.push_back((temp >> 8 ) & 0x000000FF);
              return decodedBytes;
            case 2: //Two pad characters
              decodedBytes.push_back((temp >> 10) & 0x000000FF);
              return decodedBytes;
            default:
              {
                ostringstream oss;
                oss << "Base64Codec::decode failed." << endl
                  << "A Base64 encoded string should have a maximum of 1 or two"
                  " padding('=') characters." << endl
                  << "Violated by input string:[" << inStr << "]" << endl;
                throw XPlus::Exception(oss.str());
              }
          }
        }  
        else 
        {
          ostringstream oss;
          oss << "Base64Codec::decode failed." << endl
            << "Found invalid characters in the input Base64 encoded"
            " string: [" << inStr << "]" << endl;
          throw XPlus::Exception(oss.str());
        }
        cursor++;
      }
      decodedBytes.push_back((temp >> 16) & 0x000000FF);
      decodedBytes.push_back((temp >> 8 ) & 0x000000FF);
      decodedBytes.push_back((temp      ) & 0x000000FF);
    }
    return decodedBytes;
  }

}

#if 0
int main()
{
  string input;
  while(1)
  {
    cout << "input:";
    std::getline(cin, input);
    string encodedStr = base64Encode(input);
    cout << "encodedStr:" << encodedStr << endl;
    cout << "decodedStr:" << base64Decode(encodedStr) << endl;
  }
}
#endif
