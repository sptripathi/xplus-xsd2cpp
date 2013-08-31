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

extern "C" {
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <math.h>
}
#include <sstream>

#include "XPlus/FPA.h"
#include "XSD/Sampler.h"
#include "XPlus/StringUtils.h"

namespace XMLSchema
{
  namespace Sampler
  {
    // some characters in the charset may be repeated intentionally
    // so as to increase the chances of them appearing in radom
    // string sample generated from such a charset(eg. chars[+/=] in
    // base64BinarySamples)
    const DOMString alphaCharSet = "abcdefghijklmnopqrstuvwxyz";
    const DOMString alphaNumCharSet = "abcdefghijklmnopqrstuvwxyz0123456789";
    const DOMString hexBinaryCharSet = "0A1B2C3D4E5F6A7B8C9D";

    DOMString stringSamples[CNT_SAMPLES] = {
      "a text with     spaces,\t\ttabs,\nand\nnewlines",
      "Some lines of text separated by newlines and"
      " tabs:\n\t\there goes a line of text\n\t\t..."
      "then comes another one\n\t\t...and then comes"
      " the last one"                                  ,
      "text-sample"                                    ,
      "paint your imaginations"                        ,
      "space separated string"                         ,
      "knight's moves on chessboard"                   ,
      "tab\t\tseparated\tstring"                       ,
      "la dame noire sur la rue"                       ,
      "newline\nseparated\nstring"                     ,
      "a dog is a man's best friend but my best"
      " friend happens to be a canary"
    };

    DOMString booleanSamples[CNT_SAMPLES] = {
      "true", "false", "true", "false",
      "true", "false", "true", "false",
      "true", "false"
    };

    DOMString decimalSamples[CNT_SAMPLES] = {
      "-1.23"   , "12678967.543233", "+100000.00", "210"   ,
      "-2975.49", "78967.233"      , "+0.05"     , "100000",
      "-0.579"  , "2797.323"
    };
    
    DOMString floatSamples[CNT_SAMPLES] = {
      "-1.23"   , "12678967.543233", "+100000.00", "210"   ,
      "-2975.49", "78967.233"      , "+0.05"     , "100000",
      "-0.579"  , "2797.323"
    };

    DOMString doubleSamples[CNT_SAMPLES] = {
      "-1E4", "1267.43233E12", "12.78e-2", "12"  ,
      "-4E1", "0.423E2"      , "0.78e-2" , "12.0",
      "-0"  , "0"
    };

    DOMString durationSamples[CNT_SAMPLES] = {
      "P1Y"       , "P1M"     , "P30D"             ,
      "P0Y1347M0D", "P1347Y"  , "P1347M"           ,
      "P1Y2MT2H"  , "P0Y1347M", "P1Y2M3DT10H30M40S",
      "P2Y3M4DT10H30M40S"
    };
    
    DOMString dateTimeSamples[CNT_SAMPLES] = {
      "2001-07-04T14:50:59Z"  , "2000-03-04T20:00:00Z",
      "2000-01-15T00:00:00"   , "2000-02-15T00:00:00" ,
      "2000-01-15T12:00:00"   , "2000-01-16T12:00:00Z",
      "2001-07-04T14:50:59Z"  , "2000-03-04T20:00:00Z",
      "2000-01-15T12:00:00"   , "2000-01-16T12:00:00Z"
    };

    DOMString timeSamples[CNT_SAMPLES] = {
      "14:59:57", "13:20:00-05:00" , 
      "00:45:35", "13:20:00+05:00Z", 
      "14:34:03", "13:20:00-05:00" , 
      "00:43:24", "13:20:00+05:00Z", 
      "14:54:49", "13:20:00-05:00" 
    };

    DOMString dateSamples[CNT_SAMPLES] = {
      "2010-01-04"       , "2011-01-08+05:30"  , "2002-10-09Z"     , 
      "2011-12-31"       , "2002-10-10-05:00"  , "2002-10-09Z"     ,
      "2002-10-10+05:00" , "2002-10-11Z"       , "2002-10-10-05:00", 
      "2002-10-10+05:00"
    };
    
    DOMString gYearMonthSamples[CNT_SAMPLES] = {
      "1980-11", "1970-02", "2002-07", "1940-03", "2020-01", 
      "1975-06", "1975-07", "2007-12", "1945-05", "1999-07"
    };
    
    DOMString gYearSamples[CNT_SAMPLES] = {
      "1978", "1965", "1747", "1999", "1975",
      "1973", "1970", "1752", "1994", "1980"
    };

    DOMString gMonthDaySamples[CNT_SAMPLES] = {
      "12-30", "11-27", "10-25", "09-23", "08-21", 
      "02-13", "03-15", "04-17", "05-19", "07-21" 
    };
    
    DOMString gDaySamples[CNT_SAMPLES] = {
      "01", "03", "05", "07", "09", 
      "30", "27", "24", "21", "18"
    };
    
    DOMString gMonthSamples[CNT_SAMPLES] = {
      "01", "02", "03", "04", "05", 
      "06", "07", "08", "10", "12"
    };

    DOMString hexBinarySamples[CNT_SAMPLES] = {
      "FEFF0B9C1B3C7D2B5FA9B3CB7F03C7D2B5FA9BA9B3CB7F03C7D2"  ,
      "A0B9C1D8B3CB7F03C7D2B5FA9BA9D2B5FA9B3CB7F03C7D2B"      ,
      "FA9DB3CB7F03C7D2B5FA9BA9D2B5F5FA9B3CB7F03C703C7D"      ,
      "05BF3C7D2B5FA9BA9D2B7F03C7D2B5FA9BA9D2B59B3CB7F03C"    , 
      "B7F07D2B5FA9BA9D2B7F03C7D25FA9B3CB7F3CB7F03C7D2B"      ,
      "FFFE2B7F03C7D25F7F03C7D25FA9BA9D2B5F03C7D2B52B5FCE"    , 
      "A9B3C7DAC7D25FA9BA9D2B5C7D2B5FA9BA9D2B7BA9D2B7F03B"    , 
      "7AFD3CB7F03C7D2B5FA9C7D2B5FA9BA9B37F2B5FA0B9C1D8"      ,
      "2B5FB5FA9BA9B37F2B5FA0B9C105BF3C7D2B5FA97AFD3CB7"      , 
      "B37F2B5FB5FA9BB7F07D2B5FA0B9C1D8BB7F07D2B5FA9B"
    };

    DOMString base64BinarySamples[CNT_SAMPLES] = {
      "MJ854s7FwL0X8WGe0HLacMK5G09gTb1MJg==",
      "PSB3y5nmYi0rq7gT8lsf4xRgPgUldiI=",
      "6Fe5avxF7t03Tiz23vyhq62fOe0jccZ4bNmQkg3w60wZX1T6Fe5avxF7t03Tiz23vyhq62fOe0jccZ4bNmQkg3w60wZX1T6Fe5avxF7t03Tiz23vhq62",
      "5G09gTb1MJ854s7FwL0X8WGe0HLacMK5G09gTb1MJ854s7FwLA==",
      "tMmmUQ5X2trgPnZfp5gCZktMmmUQ5X2trgPnZfp5gCZktMmmUQc=",
      "ktMmmUQ5X2trgPnZfp5gCZktMmmUQ5X2trgPnZfp5gCZ",
      "iz23vyhq62fOe0jccZ4bNmQkg3w60wZX1T6Fe5avxF7t03Tiz23vyhq62fOe0jccZ4bNmQkg3w60Zw==",
      "Q5X2trgPnZfp5gCZktMmmUQ5X2trgPnZfp5gCZktMmmUQ5X2trgPnZ0=",
      "3Tiz23vyhq62fOe0jccZ4bNmQkg3w60wZX1T6Fe5vxF7",
      "Zfp5gCZktMmmUA=="
    };

    DOMString anyURISamples[CNT_SAMPLES] = {
      "http://www.example.com/xmlplus"                                        ,
      "http://www.w3.org/TR/xml-stylesheet"                                   ,
      "gopher://spinaltap.micro.umn.edu/00/Weather/California/Los%20Angeles"  ,
      "http://www.math.uio.no/faq/compression-faq/part1.html"                 ,
      "mailto:mduerst@ifi.unizh.ch"                                           ,
      "news:comp.infosystems.www.servers.unix"                                ,
      "telnet://melvyl.ucop.edu/"                                             ,
      "http://example.org/absolute/URI/with/absolute/path/to/resource.txt"    ,
      "ftp://example.org/resource.txt"                                        ,
      "urn:issn:1535-3613"
    };
    
    DOMString QNameSamples[CNT_SAMPLES] = {
      "xsi:schemaLocation" , "ds:KeyInfoType"   ,  "xsd:hexBinary" ,  "xsl:choose"  ,
      "anElementName"      , "anAttributeName"  ,  "xsl:when"      ,  "ns1:xInt"    ,
      "xs:boolean"         , "ns2:aFont"
    };

    DOMString NOTATIONSamples[CNT_SAMPLES] = {
      "audio:wav"  , "audio:mp4"  , "audio:flv"  , "video:mp4"  ,
      "video:flv"  , "video:avi"  , "video:rm"   , "image:tiff" ,
      "image:jpg"  , "image:png"
    };

    DOMString  normalizedStringSamples[CNT_SAMPLES] = {
      "   electronic   mailing    list"      ,  "the   great wall   of     china" , 
      "   Isaac   Newton   "                 ,  "   a thick    forest  "          , 
      " James   Bond   "                     ,  "    Albert    Einstein  "        ,
      "  frequently    asked   questions  "  ,  "    xml   schema  "              , 
      "    abstract   domain    "            ,  "      errata       "
    };

    DOMString  tokenSamples[CNT_SAMPLES] = {
      "electronic mailing list"    , "the great wall of china" , "Isaac Newton"    ,
      "a thick forest"             , "James Bond"              , "Albert Einstein" ,
      "frequently asked questions" , "xml schema"              , "I was written on"
      " two lines" , " path of installation "
    };

    DOMString  languageSamples[CNT_SAMPLES] = {
      "en"    , "fr-FR" , "fr-CA" , "de-AT-1901" , "de-AT-1996" , 
      "es-ES" , "zh-CN" , "es-PR" , "fi-FI"      , "ja"
    };

    DOMString  NMTOKENSamples[CNT_SAMPLES] = {
      "007"   , "1000_000"     , "  starts_with_a_space"   , "electronic_mailing_list" , "_aFileName",
      "gregorian" , "1-10-2011" , "path_of_installation" , ".vimrc"    , "xml-schema"
    };

    DOMString  NMTOKENSSamples[CNT_SAMPLES] = {
      "gregorian 31-10-2011"                 , 
      "mycommand file ."                     ,
      "options: --sample --write --validate" , 
      ". .. file1 file2"                     , 
      ":tabe :e"                             ,
      ".env.sh .foo"                         ,
      ":e :tabe"                             ,
      ". common.sh"                          ,
      "options: --help --version"            , 
      "1000  1000_000 1000_000_000"
    };

    DOMString  NameSamples[CNT_SAMPLES] = {
      ":colonName"  , "ns2:attr1"  , "foo.bar" , "ns2:attr2" , "bar-baz" ,
      ":colonName2" , "ns1:elem1" , "noNumChar_AlphaNumChar" , "foo.bar.baz" , "ns1:elem2"
    };
    
    DOMString  NCNameSamples[CNT_SAMPLES] = {
      "colon-name" , "ns_colon_localName", "_a.name", "foo", "foo_bar.baz",
      "ns2.colon.localName2", "noColonName4", "colon_name", "noColon_noSpace_name", "aName"
    };

    DOMString  IDSamples[CNT_SAMPLES] = {
      "A1269B", "_ID", "id", "ID1", "ID2",
      "id100" , "ID" , "ID", "ID4", "ID3"
    };

    DOMString  IDREFSamples[CNT_SAMPLES] = {
      "B6434A", "_ID", "id", "ID1", "ID2",
      "id100" , "ID" , "ID", "ID4", "ID3"
    };

    DOMString  IDREFSSamples[CNT_SAMPLES] = {
      "a001 a002 a003", "100 101 102"   , "a1 a2 a3"   ,
      "ID1 ID2 ID3"   , "_ID1 _ID2 _ID3", "ID1 ID2 ID3",
      "ID1 ID2 ID3"   , "_ID1 _ID2 _ID3", "ID1 ID2 ID3",
      "500 501 502"
    };
    
    DOMString  ENTITYSamples[CNT_SAMPLES] = {
      "e1"    , "e1"     , "_e1"   , 
      "entity", "_entity", "entity",
      "e1"    , "e1"     , "_e1"   ,
      "amp"
    };
    
    DOMString  ENTITIESSamples[CNT_SAMPLES] = {
      "e1 e2 e3", "entity1 entity2 entity3", "_e1 _e2_e3", "e1 e2 e3",
      "e1 e2 e3", "entity1 entity2 entity3", "_e1 _e2_e3", "e1 e2 e3",
      "e1 e2 e3", "entity1 entity2 entity3"
    };
    
    DOMString  integerSamples[CNT_SAMPLES] = {
      "-1"            , "0"       , "100000"          , 
      "+100000"       , "-100000" , "-12678967543233" ,
      "1267896754323" , "683494"  , "-683494"         , 
      "-1000"
    };
    
    DOMString  positiveIntegerSamples[CNT_SAMPLES] = {
      "12678967543233"  , "1000000" , "1000"  , "100"  , "1"  ,
      "+12678967543233" , "+10000"  , "10000" , "+100" , "10"
    };

    DOMString  nonPositiveIntegerSamples[CNT_SAMPLES] = {
      "-12678967543233" , "-1"   , "0"      ,
      "-100000"         , "-100" , "-10"    , 
      "-1000"           , "0"    , "-10000" , 
      "-1000000"
    };
    
    DOMString  negativeIntegerSamples[CNT_SAMPLES] = {
      "-12678967543233" , "-1"    , "-500"  , "-100000" , "-100"     ,
      "-10"             , "-1000" , "-5000" , "-10000"  , "-1000000"
    };

    DOMString  nonNegativeIntegerSamples[CNT_SAMPLES] = {
      "1"   , "0"    , "12678967543233"  , "100000" , "10" ,
      "100" , "1000" , "+12678967543233" , "+10000" , "+10"
    };

    DOMString  longSamples[CNT_SAMPLES] = {
      "-1"             ,  "0"              , "12678967543233"       ,
      "+100000"        , "-92233720368547" , "-9223372036854775808" , 
      "92233720368547" , "+1"              , "10000"                ,
      "+100"
    };
    
    DOMString  unsignedLongSamples[CNT_SAMPLES] = {
      "0"  , "100"   , "12678967543233" , "100000" , "18446744073709551615" ,
      "10" , "10000" , "67543233"       , "1000"   , "73709551615"
    };

    DOMString  intSamples[CNT_SAMPLES] = {
      "-2147483648" , "2147483647"  , "-1"         , "0"  , "126789675" ,
      "+100000"     , "-2147483647" , "2147483645" , "+1" , "+126789675"
    };
    
    DOMString  unsignedIntSamples[CNT_SAMPLES] = {
      "4294967295" , "0"  , "1267896754" , "100000" , "1000" ,
      "294967295"  , "10" , "267896754"  , "10000"  , "100"
    };

    DOMString  shortSamples[CNT_SAMPLES] = {
      "32767" , "-32768" , "32765" , "-32767" , "0",
      "2767"  , "-2768"  , "2765"  , "-2767"  , "0"
    };
    
    DOMString  unsignedShortSamples[CNT_SAMPLES] = {
      "65535" , "65530" , "1000" , "10000" , "0",
      "5535"  , "5530"  , "100"  , "10"    , "0"
    };

    DOMString  byteSamples[CNT_SAMPLES] = {
      "-128", "127", "0", "126", "100",
      "-129", "120", "1", "125", "10"
    };

    DOMString  unsignedByteSamples[CNT_SAMPLES] = {
      "255" , "0"  , "126" , "100" , "254" ,
      "55"  , "10" , "26"  , "10"  , "54"
    };
   
    //~~~~~~~~~~~~~~  generic string  samplers  ~~~~~~~~~~~~

    DOMString getRandomSample(vector<DOMString> samples)
    {
      unsigned int len = samples.size();
      int idx = nonnegativeIntegerRandom(len);
      return samples[idx];
    }

    DOMString getRandomSample(DOMString *arrSamples, int lenSamples)
    {
      int idx = nonnegativeIntegerRandom(lenSamples);
      return arrSamples[idx];
    }
    
    DOMString getRandomSampleStringOfLength(int length, DOMString charSet)
    {
      ostringstream oss;
      int idx=0;
      int charSetLen = charSet.length(); 
      for(unsigned int i=0; i<length; i++)
      {
        idx = nonnegativeIntegerRandom(charSetLen);
        oss << charSet[idx];
      }
      return oss.str();
    }
    
    DOMString getRandomSampleStringOfLengthRange(int minLength, int maxLength, DOMString charSet)
    {
      int randLen = integerRandomInRange(minLength, maxLength+1); 
      return getRandomSampleStringOfLength(randLen, charSet);
    }
    
#define MAXLEN_STRING_SAMPLE 100
    DOMString getRandomSampleStringOfMinLength(int minLength, DOMString charSet)
    {
      int randAddlLen = nonnegativeIntegerRandom(MAXLEN_STRING_SAMPLE); 
      return getRandomSampleStringOfLength(minLength+randAddlLen, charSet);
    }
    
    DOMString getRandomSampleStringOfMaxLength(int maxLength, DOMString charSet)
    {
      int length = nonnegativeIntegerRandom(maxLength);
      return getRandomSampleStringOfLength(length, charSet);
    }

    //~~~~~~~~~~~~~~  base64Binary  ~~~~~~~~~~~~


  /***************************************************

    base64Binary - analysis of parts of the regex :
    ===============================================
 
    Regex: ((([A-Za-z0-9+/]\\s?){4})*(([A-Za-z0-9+/]\\s?){3}[A-Za-z0-9+/]|([A-Za-z0-9+/]\\s?){2}[AEIMQUYcgkosw048]\\s?=|[A-Za-z0-9+/]\\s?[AQgw]\\s?=\\s?=))?           

    1) Prefix with occurence as series : 0, 4, 8, 12, ...
        pattern :  ([A-Za-z0-9+/]\s?){4})*
        example :  bn10

    2) Suffix with fixed length = 4, with 3 options of regexes

      a) option 1 
        pattern : ([A-Za-z0-9+/]\s?){3}[A-Za-z0-9+/]
        example : "asd9", "a sd9", "a s d9", "a s d 9"

      b) option 2 
        pattern : ([A-Za-z0-9+/]\s?){2}[AEIMQUYcgkosw048]\s?=
        example : "asw=", "a s w =" 

      c) option 3
        pattern : [A-Za-z0-9+/]\s?[AQgw]\s?=\s?=
        example : "aw==", "a w = ="

  *****************************************************/

/*
    int base64OctetLenToLexLen(int octetLen)
    {
      return ceil(octetLen/3)*4;
    }
    
    // length := floor (length(lex3) * 3 / 4)  
    // lexLen should have whitespace stripped and padding removed
    int base64LexLenToOctetLen(int lexLen)
    {
      return floor(lexLen/4)*3;
    }
*/
    DOMString getRandomSampleBase64StringOfLength(int octetLen)
    {
      // first 4 chars of base64BinaryCharSet that are optional 
      // if lexLen <= 4
      static  DOMString base64Optional4CharSet = "abcdefghijklmnopqrstuvwxyz"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890123456789+/";

      DOMString prefix="", suffix="";
      int lastGroupOctets = octetLen%3;
      int prefixLen = (octetLen - lastGroupOctets)*4/3;  
      if(prefixLen > 0) {
        prefix = getRandomSampleStringOfLength(prefixLen, base64Optional4CharSet);
      }

      switch(lastGroupOctets)
      {
        case 0:
            suffix = "";
          break;

        case 2:
          {
            static DOMString suffixCharSet2b = "AEIMQUYcgkosw048";
            DOMString suffix1 = getRandomSampleStringOfLength(2, base64Optional4CharSet);
            DOMString suffix2 = getRandomSampleStringOfLength(1, suffixCharSet2b);
            suffix = suffix1 + suffix2 + "=";
          }
          break;

        case 1:
          {
            static DOMString suffixCharSet2c = "AQgw";
            DOMString suffix1 = getRandomSampleStringOfLength(1, base64Optional4CharSet);
            DOMString suffix2 = getRandomSampleStringOfLength(1, suffixCharSet2c);
            suffix = suffix1 + suffix2 + "==";
          }
          break;
        
        default:
          suffix="";
          break;
      }
      return prefix+suffix;
    }
    
    DOMString getRandomSampleBase64StringOfLengthRange(int minOctetLen, int maxOctetLen)
    {
      int randLen = integerRandomInRange(minOctetLen, maxOctetLen+1);
      return getRandomSampleBase64StringOfLength(randLen);
    }

    DOMString getRandomSampleBase64StringOfMinLength(int minOctetLen)
    {
      //lets take unbounded maxOctetLen as minOctetLen + some-constant
      int maxOctetLength = minOctetLen + 40;
      int randLen = integerRandomInRange(minOctetLen, maxOctetLength+1);
      return getRandomSampleBase64StringOfLength(randLen);
    }
    
    DOMString getRandomSampleBase64StringOfMaxLength(int maxOctetLen)
    {
      int minOctetLen = 0;
      int randLen = integerRandomInRange(minOctetLen, maxOctetLen+1);
      return getRandomSampleBase64StringOfLength(randLen);
    }
    
    //~~~~~~~~~~~~~~  anyURI  ~~~~~~~~~~~~

    // For anyURI, length is measured in units of characters (as for string).
    // Such a character does not always map to one octet.

    // "http://example.com"           : 18
    // "http://example.com/"          : 19
    // "http://www.example.com"       : 22
    // "http://www.example.com/"      : 23
    DOMString getUrlSchemeSample(int len)
    {
      // len 18
      static DOMString example_urls[] = {
        "http://example.com",
        "http://example.org",
        "http://example.net"
      };

      // len 22
      static DOMString www_example_urls[] = {
        "http://www.example.com",
        "http://www.example.org",
        "http://www.example.net"
      };

      assert(len>=18);
      int toss = nonnegativeIntegerRandom(3);

      if(len == 18)
      {
        return example_urls[toss];
      }
      else if(len < 22) 
      {
        int suffixLen = len -19;
        DOMString suffix = getRandomSampleStringOfLength(suffixLen, alphaCharSet); 
        return example_urls[toss] + "/" + suffix;        
      }
      else if(len == 22)
      {
        return www_example_urls[toss];
      }
      else
      {
        int suffixLen = len - 23;
        DOMString suffix = getRandomSampleStringOfLength(suffixLen, alphaCharSet); 
        return www_example_urls[toss] + "/" + suffix;        
      }
    }

    // "urn:"   : 4
    DOMString getUrnSchemeSample(int len)
    {
      assert(len > 4);
      return DOMString("urn:") + getRandomSampleStringOfLength(len-4, alphaCharSet);
    }

    DOMString getRandomSampleAnyURIOfLength(int len)
    {
      if(len >= 18) {
        return getUrlSchemeSample(len);
      }
      else if(len > 4) {
        return getUrnSchemeSample(len);
      }
      // len:[0,4] : generate a relative uri
      else
      {
        if(len > 2) {
          return DOMString("./") + getRandomSampleStringOfLength(len-2, alphaCharSet);
        }
        else {
          return getRandomSampleStringOfLength(len, alphaCharSet);
        }
      }
    }

    DOMString getRandomSampleAnyURIOfLengthRange(int minLen, int maxLen)
    {
      int randLen = integerRandomInRange(minLen, maxLen+1);
      return getRandomSampleAnyURIOfLength(randLen);
    }

    DOMString getRandomSampleAnyURIOfMinLength(int minLen)
    {
      //lets take unbounded maxLen as minLen + some-constant
      int maxLen = minLen + 30;
      int randLen = integerRandomInRange(minLen, maxLen+1);
      return getRandomSampleAnyURIOfLength(randLen);
    }
    
    DOMString getRandomSampleAnyURIOfMaxLength(int maxLen)
    {
      int minLen = 0;
      int randLen = integerRandomInRange(minLen, maxLen+1);
      return getRandomSampleAnyURIOfLength(randLen);
    }


    //~~~~~~~~~~~~~~  double  ~~~~~~~~~~~~
    DOMString getRandomSampleDouble(double minIncl, double maxIncl)
    {
      double doubleStep = 0;
      double diff = maxIncl - minIncl;
      if(diff <10 ) {
        doubleStep = (diff / 100) * nonnegativeIntegerRandom(95);
      }
      else
      {
        UInt64 intDiff = static_cast<UInt64>(ABS(maxIncl - minIncl));
        unsigned long long step = integerRandomInRange(1, intDiff);
        //drand48 generates random in range [0,1]
        doubleStep = step - drand48();
      }
      
      double outDouble = minIncl + doubleStep;
#if 0
      // if the generated double doesn't comply to totalDigits/fractionDigits
      // constraints then some warning to user is the best we could do for now
      unsigned int myIntegralDigits = 0, myFractionalDigits = 0;
      XPlus::FPA::countIntegralAndFractionDigits( outDouble, myIntegralDigits, myFractionalDigits);
      int maxTotalDigits = (totalDigits != -1) ? totalDigits : 1000; 
      int maxFractionalDigits = (fractionDigits != -1) ? fractionDigits : 100; 
      if( 
          (myFractionalDigits > maxFractionalDigits) ||
          ( (myIntegralDigits+ myFractionalDigits) > maxTotalDigits)
        )  
      {
        cerr << "While generating a sample value for double, failed to"
          " guess a sample value that satisfies totalDigits/fractionDigits constraints."
          " Using an invalid sample value anyway."
          << endl;
      }
#endif      
      return toString<double>(outDouble);
    }

    DOMString getRandomSampleDoubleOfDigits(int totalDigits, int fractionDigits)
    {
      // moderate the values to avoid overflow, in case the schema specifies 
      // too large a number for totalDigits and/or fractionDigits
      int modestIntegralDigits =0, modestFractionDigits =0;
      if( (totalDigits != -1) && (fractionDigits != -1) )
      {
        modestFractionDigits = (fractionDigits > 4) ? 4 : fractionDigits;
        int integralDigits = totalDigits - modestFractionDigits;
        modestIntegralDigits = (integralDigits > 8) ? 8 : integralDigits;
      }
      else if(totalDigits != -1)
      {
        // let's assume some modest value for fractionDigits
        modestFractionDigits = 3;
        int integralDigits = totalDigits - modestFractionDigits;
        modestIntegralDigits = (integralDigits > 8) ? 8 : integralDigits;
      }
      else if(fractionDigits != -1)
      {
        modestFractionDigits = (fractionDigits > 4) ? 4 : fractionDigits;
        // let's assume some modest value for integralDigits
        modestIntegralDigits = 7;
      }

      DOMString integralStr = "", fractionStr = "", outStr = "";
      int randFractionDigits = nonnegativeIntegerRandom(modestFractionDigits+1);
      int randIntegralDigits = nonnegativeIntegerRandom(modestIntegralDigits+1);
      integralStr = getRandomSampleLongOfLength( nonnegativeIntegerRandom(randIntegralDigits+1) );
      fractionStr = getRandomSampleLongOfLength( nonnegativeIntegerRandom(randFractionDigits+1) );
      outStr = integralStr + ( (fractionStr.length() > 0) ? 
                             (DOMString(".") + fractionStr) : "" );
      
      // handle the case when both random randFractionDigits and randIntegralDigits are 0
      if(outStr.length() == 0) {
        outStr = "0"; 
      }
      return outStr;
    }


    //~~~~~~~~~~~~~~  long  ~~~~~~~~~~~~
    DOMString getRandomSampleLongOfLength(int len)
    {
      ostringstream oss;
      for(int i=0; i<len; i++)
      {
        int digit = integerRandomInRange(1,10);
        oss << digit;
      }
      return oss.str();
    }

    DOMString getRandomSampleLong(Int64 minIncl, Int64 maxIncl)
    {
      assert(minIncl <= maxIncl);
      UInt64 numSamples = static_cast<unsigned long long>(ABS(maxIncl - minIncl +1));
      UInt64 step = nonnegativeIntegerRandom(numSamples);
      return toString<Int64>(minIncl + step);
    }

    //~~~~~~~~~~~~~~  random generators  ~~~~~~~~~~~~

    // produces nonnegativeInteger in range [0, maxExcl-1]
    UInt64 nonnegativeIntegerRandom(UInt64 maxExcl)
    {
      assert(maxExcl > 0);
      srand48( time(NULL)%10001 + lrand48()%10001 );
      long int r = lrand48()%(maxExcl);
      return r;
    }
    
    // need random integer in range [minIncl, maxExcl-1]
    // ie [0, maxExcl-1-minIncl] + minIncl
    Int64 integerRandomInRange(Int64 minIncl, Int64 maxExcl)
    {
      assert(maxExcl > minIncl);
      return (nonnegativeIntegerRandom(maxExcl-minIncl) + minIncl);
    }


  }// end namespace Sampler

}// end namespace XMLSchema

